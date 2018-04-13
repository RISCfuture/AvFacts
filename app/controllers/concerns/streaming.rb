# Controller mixin that allows you to stream data from an outbound, server-side
# HTTP request. To use, `include` this module in your controller. In your
# action, call the {#stream} method. The outbound server-side request will have
# its headers and method set to match the inbound request. Likewise, the
# response back to the client will have its code, headers, and body set to match
# the response received from the remote location.

module Streaming
  extend ActiveSupport::Concern

  included do
    include ActionController::Live
  end

  protected

  PASS_THROUGH_REQUEST_HEADERS  = %w[Accept Range]
  PASS_THROUGH_RESPONSE_HEADERS = %w[Content-Type Content-Length Range Accept-Range]
  private_constant :PASS_THROUGH_REQUEST_HEADERS, :PASS_THROUGH_RESPONSE_HEADERS

  # Streams data to the client from a given URL. Request method, request
  # headers, response code, and response headers are also set to match.
  #
  # @param [String] url The URL to stream data from.

  def stream(url)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request_class = request.head? ? Net::HTTP::Head : Net::HTTP::Get

      outbound_request = request_class.new(uri.request_uri)
      PASS_THROUGH_REQUEST_HEADERS.each do |header|
        outbound_request[header] = request.headers[header]
      end

      http.request(outbound_request) do |outbound_response|
        response.status = outbound_response.code.presence&.to_i
        PASS_THROUGH_RESPONSE_HEADERS.each do |header|
          response.headers[header] = outbound_response[header]
        end

        outbound_response.read_body { |chunk| response.stream.write chunk }
      end
    end
  ensure
    response.stream.close
  end
end
