class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def store_last_page
    session[:last_page] = request.fullpath
  end

  def retrieve_last_page_or_default(default_path: root_path)
    session[:last_page] || default_path
  end
  
  helper_method :retrieve_last_page_or_default

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, 
      keys: [:username, :phone_number, :full_name])
    devise_parameter_sanitizer.permit(:account_update, 
      keys: [:username, :phone_number, :full_name, :profile_pic, :bio, :private])
  end
end
