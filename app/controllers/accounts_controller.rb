class AccountsController < ApplicationController
  before_action :authenticate_user!
  
  def change_current
    current_user.change_current_account_to(account_param)
    redirect_to day_records_path
  end

  private

  def account_param
    params.require(:id)
  end

end
