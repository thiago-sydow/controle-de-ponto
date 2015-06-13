module AccountManipulable
  extend ActiveSupport::Concern

  include CltWorkerAccountManipulable

  def account_manipulate_balance(balance)
    clt_manipulate_balance(balance) if account.class == CltWorkerAccount
  end

  def account_manipulate_over_diff(diff, worked_hours, index)
    clt_manipulate_over_diff(diff, worked_hours, index) if account.class == CltWorkerAccount
  end

end
