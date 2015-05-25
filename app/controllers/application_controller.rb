class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  
  def set_dashboard
    return nil unless current_user
    @dashboard ||= DashboardPresenter.new(current_user.current_account)
  end

end
