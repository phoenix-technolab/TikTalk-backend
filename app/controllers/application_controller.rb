class ApplicationController < ActionController::API
  include RenderMethods
  before_action :authentication!, :set_default_format

  def authentication!
    if current_user.blank?
      render json: { error: "Sorry, you are not authtorize" }, status: 401
    end
  end

  def current_user
    @current_user ||= User.where("? = ANY (tokens)", request.headers["Auth-token"]).first
  end

  def set_default_format
    request.format = :json unless params[:format]
  end
  
end
