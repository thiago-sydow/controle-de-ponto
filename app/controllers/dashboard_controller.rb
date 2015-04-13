class DashboardController < ApplicationController
  def index
    @balance = current_user.day_records.inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
    @total_worked = current_day_record.try(:total_worked) || Time.current.midnight
    @departure_time = current_day_record.try(:forecast_departure_time) || Time.current.midnight
  end

  private

  def current_day_record
    @current_day_record ||= current_user.day_records.where(reference_date: Date.current).first
  end
end
