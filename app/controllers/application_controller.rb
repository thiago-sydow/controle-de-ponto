class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:gender, :birthday]

  end

end
