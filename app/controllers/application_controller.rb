class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery prepend: true, with: :exception

  around_action :set_time_zone, if: :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def set_presenter
    return nil unless current_user
    @account_presenter ||= AccountPresenter.new(current_user.current_account)
  end

  private

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
