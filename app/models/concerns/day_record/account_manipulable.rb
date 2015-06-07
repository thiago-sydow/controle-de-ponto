module DayRecord::AccountManipulable
  include DayRecord::CltWorkerAccountManipulable
  extend ActiveSupport::Concern
  
  included do
    
  end

  def account_manipulate_balance
    clt_manipulate_balance if account.class == CltWorkerAccount
  end

  def account_manipulate_over_diff(diff, worked_hours, index)
    clt_manipulate_over_diff(diff, worked_hours, index) if account.class == CltWorkerAccount
  end

end