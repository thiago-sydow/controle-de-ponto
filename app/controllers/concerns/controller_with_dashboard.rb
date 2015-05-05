module ControllerWithDashboard
  extend ActiveSupport::Concern

  included do
    before_action :set_dashboard, except: [:update, :destroy, :create]
  end


  def set_dashboard
    @dashboard ||= DashboardPresenter.new(current_user)
  end

end
