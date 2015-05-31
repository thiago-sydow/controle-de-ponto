class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  
  def set_presenter
    return nil unless current_user
    @account_presenter ||= AccountPresenter.new(current_user.current_account)
  end

end
