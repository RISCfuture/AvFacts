# Helper methods for the RSS and JSON views of {EpisodesController}.

module EpisodesHelper

  # @return [Hash<String, Object>] Returns a hash of configuration information
  #   about the AvFacts podcast, used for populating the RSS feed with channel
  #   information. This data is defined in `config/channel.yml`.

  def channel
    @channel ||= recursive_openstruct(YAML.load_file(Rails.root.join('config', 'channel.yml').to_s))
  end

  # @return [Time] The date of the most recently-published episode, which serves
  #   as the RSS feed's publication date.

  def publication_date
    @pubdate ||= Episode.published.order(published_at: :desc).first.published_at
  end

  # Returns the full formatted title of the episode used in the episode list
  # (e.g., "#5: Title Name").
  #
  # @param [Episode] episode The episode.
  # @return [String] The full episode title as used in the feed.

  def full_title(episode)
    "##{number_with_delimiter episode.number}: #{episode.title}"
  end

  # Given a duration in seconds, returns a colon-separated formatted duration.
  # For example, 350 seconds becomes "0:05:50".
  #
  # @param [Integer] seconds A duration in seconds.
  # @return [String] The formatted duration as colon-separated components.

  def duration_string(seconds)
    seconds = seconds.round
    hours   = (seconds/3600)
    minutes = (seconds - hours*3600)/60
    seconds = seconds - hours*3600 - minutes*60
    return [
        hours.to_s,
        minutes.to_s.rjust(2, '0'),
        seconds.to_s.rjust(2, '0')
    ].join(':')

  end

  private

  def recursive_openstruct(hsh)
    OpenStruct.new(hsh.inject({}) do |converted, (k, v)|
      converted[k] = case v
                       when Hash
                         recursive_openstruct(v)
                       else
                         v
                     end
      converted
    end)
  end
end
