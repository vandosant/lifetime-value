class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ensure_current_user

  def ensure_current_user
    redirect_to signin_path unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_is_admin?
    user = current_user
    user.is_admin
  end

  helper_method :current_user, :user_is_admin?

end
