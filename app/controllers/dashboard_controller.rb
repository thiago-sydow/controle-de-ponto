class DashboardController < ApplicationController
  def index
    @balance = current_user.day_records.inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance); sum_balance }
    @total_worked = current_user.day_records.where(reference_date: Date.current).first.try(:total_worked) || Time.current.midnight
  end
end
