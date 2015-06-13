module AccountManipulable
  extend ActiveSupport::Concern

  include CltWorkerAccountManipulable

  def account_manipulate_balance(balance)
    clt_manipulate_balance(balance, account.allowance_time) if is_clt_account?
  end

  def account_manipulate_over_diff(diff, worked_hours, index)
    clt_manipulate_over_diff(diff, worked_hours, index) if is_clt_account?
  end

  protected

  def is_clt_account?
    account.class == CltWorkerAccount
  end

end