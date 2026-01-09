class ApplicationController < ActionController::Base
  # Pundit authorization set up
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def index
    if user_signed_in?
      redirect_to dashboard_path
    else
      render "/index"
    end
  end

  private
  def user_not_authorized
    flash[:alert] = "No estás autorizado a realizar esta operación."
    redirect_back_or_to(root_path)
  end
end
