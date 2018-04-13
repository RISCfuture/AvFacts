# @abstract
#
# Abstract superclass for all controllers in AvFacts.

class ApplicationController < ActionController::Base
  before_action :set_storage_host

  protected

  # `before_action` that requires an active user session. Calls
  # {#unauthorized_response} if there is not authenticated user session.

  def admin_required
    if admin?
      return true
    else
      unauthorized_response
      return false
    end
  end

  # Default behavior when an authenticated session is required but not present.
  # Renders a 401 Unauthorized response.

  def unauthorized_response
    respond_to do |format|
      format.json { render json: {error: 'admin_required'}, status: :unauthorized }
      format.any { head :unauthorized }
    end
  end

  # @return [true, false] Whether or not an authenticated session is present.

  def admin?
    return session[:user_id].present?
  end

  private

  def set_storage_host
    # really only needed for DiskService in dev/test
    ActiveStorage::Current.host = request.base_url
  end
end
