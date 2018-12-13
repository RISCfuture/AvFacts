require 'transcode'

# An episode of the AvFacts podcast. Each episode is associated with a source
# audio file, which is managed by Active Storage and transcoded using the
# {Transcode} library using FFMPEG. Active Storage is also used for a linked
# image.
#
# Each episode is given a unique number representing its order in the series.
# They also have a `published_at` date, before which it's not published to the
# RSS feed and website.
#
# Active Storage normally does image transformations on demand, and the
# `Transcode` class inherits that philosophy. However, this model has an
# after-save hook that pre-processes the transcoding and image variants.
#
# An episode can be created without audio and image assets. It exists in a
# "draft" state until the audio and image files are uploaded and fully
# processed. At that point the `processed` attribute is set to `true` at the
# episode is available for streaming (see {#preprocess!}).
#
# Attached Files
# --------------
#
# |         |                                                                  |
# |:--------|:-----------------------------------------------------------------|
# | `audio` | The source audio file (used to also access transcoded versions). |
# | `image` | The image associated with this episode.                          |
#
# Properties
# ----------
#
# |                |                                                                                                                     |
# |:---------------|:--------------------------------------------------------------------------------------------------------------------|
# | `number`       | The episode number, sequentially incrementing from 1.                                                               |
# | `title`        | The name of the episode.                                                                                            |
# | `subtitle`     | A short subtitle to appear below the title in iTunes.                                                               |
# | `summary`      | A one or two sentence summary of the episode.                                                                       |
# | `description`  | A longer paragraphical description of the episode.                                                                  |
# | `credits`      | A freeform textual field where voice and production credits are listed, if other people contributed to the episode. |
# | `author`       | The episode author. (Defaults to the channel author in `config/channel.yml`).                                       |
# | `script`       | The original episode script, in Markdown format. Not published to the website or feed but used in fulltext search.  |
# | `published_at` | The date after which the episode will appear on the website and feed.                                               |
# | `explicit`     | If `true`, the episode is marked in iTunes as having explicit content.                                              |
# | `blocked`      | If `true`, the episode is removed from iTunes.                                                                      |
# | `processed`    | If `true`, all required assets have been included and the episode is ready for publication.                         |

class Episode < ApplicationRecord

  # The FFMPEG options used when transcoding to MP3 format.
  MP3_OPTIONS = %w[-c:a libmp3lame -b:a 192k -ac 2].freeze

  # The FFMPEG options used when transcoding to AAC format.
  AAC_OPTIONS = %w[-c:a libfdk_aac -b:a 128k -ac 2].freeze

  validates :number,
            presence:     true,
            uniqueness:   true,
            numericality: {only_integer: true, greater_than: 0},
            strict:       true
  validates :title,
            presence: true,
            length:   {maximum: 255}
  validates :subtitle, :summary, :author,
            length:    {maximum: 255},
            allow_nil: true
  validates :description,
            presence: true,
            length:   {maximum: 4000}
  validates :credits,
            length:    {maximum: 1000},
            allow_nil: true
  validates :published_at,
            presence:   {strict: true},
            timeliness: {type: :datetime}

  has_one_attached :audio
  has_one_attached :image

  before_validation :set_number, on: :create
  before_validation :set_published_at
  after_commit :schedule_preprocess

  scope :published, -> { where 'episodes.published_at <= ? AND episodes.processed IS TRUE', Time.current }

  extend SetNilIfBlank
  set_nil_if_blank :subtitle, :summary, :author, :credits

  # @return [true, false] Whether or not the episode should be public on the
  #   website and RSS feed.

  def published?
    Time.current >= published_at
  end

  # @return [Transcode, nil] The MP3 version of the `audio` file (processed
  #   on-demand).

  def mp3
    return nil if audio.attachment.nil?

    audio.transcode 'mp3', MP3_OPTIONS
  end

  # @return [Transcode, nil] The AAC version of the `audio` file (processed
  #   on-demand).

  def aac
    return nil if audio.attachment.nil?

    audio.transcode 'aac', AAC_OPTIONS
  end

  # @return [ActiveStorage::Variant, nil] The thumbnail version of the episode
  #   image.

  def thumbnail_image
    return nil if image.attachment.nil?
    return nil unless image.metadata['width'] && image.metadata['height']

    image.thumbnail(200)
  end

  # @return [ActiveStorage::Variant, nil] The version of this image for use with
  #   the iTunes RSS feed.

  def itunes_image
    return nil if image.attachment.nil?
    return nil unless image.metadata['width'] && image.metadata['height']

    image.thumbnail(3000)
  end

  # @private
  def to_param() number.to_s end

  # This method prepares an episode for release, or updates associated assets
  # post-release. It does the following:
  #
  # * Pre-transcodes the audio file into MP3 and AAC formats
  # * Pre-generates the thumbnail image
  # * Pre-analyzes the audio and image files
  #
  # If the episode is now ready for publication (all assets included and
  # processed), the following occurs:
  #
  # * `published_at` date is advanced if it's in the past
  # * `processed` field is set to true
  #
  # @param [true, false] include_delay If `true`, waits 10 seconds after
  #   processing/transcoding the image and audio data, to ensure that S3 and the
  #   CDN servers have a beat to make the data available before subscribers
  #   start downloading the podcast.

  def preprocess!(include_delay: false)
    was_not_ready = !ready?

    if audio.attachment
      audio.analyze
      mp3.processed
      aac.processed

      self.mp3_size = mp3.byte_size
      self.aac_size = aac.byte_size
    end

    if image.attachment
      image.analyze
      thumbnail_image.processed if thumbnail_image.kind_of?(ActiveStorage::Variant)
      itunes_image.processed if itunes_image.kind_of?(ActiveStorage::Variant)
    end

    sleep(10) if include_delay

    return unless was_not_ready && ready?

    self.published_at = Time.current if published_at.past?
    self.processed = true
    save!
  end

  private

  def ready?
    audio.attachment && image.attachment &&
        mp3.processed? && aac.processed? && thumbnail_image.send(:processed?)
  end

  def schedule_preprocess
    ProcessEpisodeJob.perform_later(self)
  end

  def set_number
    self.number ||= (self.class.maximum(:number) || 0) + 1
  end

  def set_published_at
    self.published_at ||= Time.current
  end
end
