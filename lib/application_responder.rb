# Base responder behavior for all controllers in the application. Standard Rails
# responder behavior, except that for successful create or update actions in
# JSON format, renders the created object as the JSON response. Create response
# codes remain 201 Created; but update response codes become 200 OK.

class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  # @private
  def api_behavior
    if format == :json
      if post? || put? || patch?
        render 'show', status: (post? ? :created : :ok)
      else
        super
      end
    else
      super
    end
  end
end
