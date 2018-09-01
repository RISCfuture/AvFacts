require 'transcode'

# Represents an encoding format and encoding options used to transcode an audio
# file from one format to another. This is an analog to the
# `ActiveStorage::Variation` class for images. An encoding can be coded into a
# URL.

class Transcode::Encoding

  # @return [String] The format to transcode, as a file extension, such as
  #   "mp3".
  attr_reader :format

  # @return [Array<String>, Hash<String, String>] Either an array of FFMPEG
  #   transcode options (such as "-a:c 1") or a set of StreamIO options for
  #   FFMPEG (such as `{audio_channels: 1}`).
  attr_reader :options

  # @private
  def self.wrap(descriptor, options=nil)
    case descriptor
      when self
        descriptor
      when Hash
        decode descriptor[:key]
      when String
        new descriptor, options
      else
        raise ArgumentError, "Can't wrap #{descriptor.class}"
    end
  end

  # @private
  def self.decode(key)
    new(*ActiveStorage.verifier.verify(key, purpose: :encoding))
  end

  # @private
  def self.encode(format, options)
    ActiveStorage.verifier.generate([format, options], purpose: :encoding)
  end

  # @private
  def initialize(format, options=nil)
    format.kind_of?(String) or raise ArgumentError, "expect string format, got #{format.class}"

    @format  = format
    @options = options || {}
  end

  # @return [String] The coded key to use in URLs when describing this transcode
  #   operation.

  def key
    self.class.encode format, options
  end

  # @return [String] The file extension to use for transcoded files, including
  #   the leading period.

  def extension
    '.' + format
  end

  # @return [Mime::Type] The MIME type instance associated with the transcoded
  #   file format.

  def mime_type
    Mime::Type.lookup_by_extension(format)
  end
end
