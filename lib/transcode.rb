require 'tempfile'

# Represents an on-demand transcoded variant of an Active Storage audio file.
# A Transcode instance stores an `ActiveStorage::Blob` and a
# {Transcode::Encoding} instance representing the transcode format and options.
#
# This class is designed to be functionally similar to the
# `ActiveStorage::Variant` class, which handles ImageMagick transformations. The
# instance will only actually perform the transcode operation when necessary, or
# when the {#processed} method is called.
#
# Create instances of this class by calling the `#transcode` method on an
# Active Storage field: `my_model.attached_audio.transcode([...])`.
#
# The hook code that adds this class's features to Active Storage is in
# `config/initializers/transcode.rb`.

class Transcode

  # @return [ActiveStorage::Blob] The associated blob to be transcoded.
  attr_reader :blob

  # @return [Transcode::Encoding] The format to transcode to and transcoding
  #   options.
  attr_reader :encoding

  delegate :service, to: :blob

  # @private
  def initialize(blob, *encoding_or_encoding_key)
    blob.kind_of?(ActiveStorage::Blob) or raise ArgumentError, "expected ActiveStorage::Blob, got #{blob.class}"
    @blob, @encoding = blob, Encoding.wrap(*encoding_or_encoding_key)
  end

  # Runs the transcode operation and returns this instance.
  #
  # @return [Transcode] This instance.

  def processed
    process unless processed?
    self
  end

  # @return [String] A unique key to use in URLs for this variant.

  def key
    "transcoded/#{blob.key}/#{Digest::SHA256.hexdigest encoding.key}"
  end

  # @return [String] The file name to use for this transcoded variant.

  def filename
    ActiveStorage::Filename.new(blob.filename.base + encoding.extension)
  end

  # @return [String] The URL to the transcoded variant within the storage
  #   system.

  def service_url(expires_in: service.url_expires_in, disposition: :inline)
    service.url key, expires_in: expires_in, disposition: disposition, filename: filename, content_type: content_type
  end

  # Returns the public, unsigned URL for the transcoded variant, as hosted by
  # the content delivery network. If no content delivery network is configured,
  # returns the {#service_url}.
  #
  # @params options Options to pass to {#service_url} if no CDN is configured.
  # @return [String] The public, unsigned URL for the transcoded variant as
  #   hosted by the content delivery network.

  def public_cdn_url(**options)
    url = URI.parse(service.public_url(key))
    if AvFacts::Configuration.storage.cloudfront_domain
      url.host = AvFacts::Configuration.storage.cloudfront_domain
    end
    return url.to_s
  rescue NotImplementedError
    # convert the path into a URL, if it's a path
    url = service_url(**options)
    if url.start_with?('/')
      url, query = url.split('?')
      defaults   = ApplicationController.renderer.defaults
      klass      = defaults[:https] ? URI::HTTPS : URI::HTTP
      uri        = klass.build(host: defaults[:http_host], port: defaults[:port], path: url, query: query)
      url        = uri.to_s
    end
    return url
  end

  # Downloads or streams the data for the transcoded variant.
  #
  # @overload download
  #   @return [IO] The downloaded data, as an I/O stream.
  # @overload download
  #   @yield (chunk) A block to run as new data is streamed.
  #   @yieldparam [String] chunk A sequential chunk of streamed data.

  def download(&block)
    processed.service.download key, &block
  end

  # @return [String] The MIME type of the transcoded variant.

  def content_type
    encoding.mime_type.to_s
  end

  # @return [Integer] The size of the transcoded variant, in bytes.

  def byte_size
    processed.service.byte_size key
  end

  # @return [true, false] If this instance has been processed yet.
  # @see #processed

  def processed?
    service.exist?(key)
  end

  private

  def process
    transcoded = transcode(service.download(blob.key))
    service.upload key, transcoded
    transcoded.close!
  end

  def transcode(io)
    in_tempfile = Tempfile.new("avfacts_blob_#{blob.id}_in", encoding: 'ascii-8bit')
    in_tempfile.write io
    in_tempfile.flush

    out_tempfile = Tempfile.new(["avfacts_blob_#{blob.id}_out", encoding.extension], encoding: 'ascii-8bit')

    movie = FFMPEG::Movie.new(in_tempfile.path)
    movie.transcode(out_tempfile.path, encoding.options)

    return out_tempfile
  ensure
    in_tempfile&.close!
  end
end

require 'transcode/encoding'
