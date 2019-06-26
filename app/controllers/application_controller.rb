class ApplicationController < ActionController::API
  before_action :authentication!

  def authentication!
    if current_user.blank?
      render json: { error: "Sorry, you are not authtorize" }, status: 401
    end
  end

  def current_user
    @current_user ||= User.where("? = ANY (tokens)", request.headers["Auth-token"]).first
  end
end
