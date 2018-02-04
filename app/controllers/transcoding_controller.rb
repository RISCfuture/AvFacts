require 'base64'

# Active Storage-like controller that redirects to the URL for a transcoded
# variant of an audio file.

class TranscodingController < ApplicationController

  # Redirects to the service URL for the transcoded variant of an audio file.
  # Performs the transcoding if necessary. The parameters are the same as for
  # other internal Active Storage controllers.
  #
  # See the {Transcode} class for more information on the `encoding_key`
  # parameter.

  def show
    if (blob = ActiveStorage::Blob.find_signed(params[:signed_blob_id]))
      expires_in ActiveStorage::Blob.service.url_expires_in
      transcode = Transcode.new(blob, key: params[:encoding_key])
      redirect_to transcode.processed.service_url(disposition: params[:disposition])
    else
      head :not_found
    end
  end
end
