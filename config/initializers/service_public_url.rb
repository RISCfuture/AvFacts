# Adds the `public_cdn_url` method to Active Storage services.

module ServicePublicURL
  module Base

    # Returns the public URL for an object, appropriate for rewriting to use a
    # content delivery network.
    #
    # @param [String] key The object key (path where it is stored).
    # @return [String] The public URL.

    def public_url(_key)
      raise NotImplementedError
    end
  end

  module S3
    def public_url(key)
      object_for(key).public_url
    end
  end
end

Rails.application.config.to_prepare do
  require 'active_storage/service/s3_service'

  ActiveStorage::Service.include ServicePublicURL::Base
  ActiveStorage::Service::S3Service.include ServicePublicURL::S3
end
