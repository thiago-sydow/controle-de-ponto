class DashboardPresenter < Burgundy::Item

  def total_balance
    @total_balance ||= day_records.inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
  end

  def total_worked
    @total_worked ||= current_day_record.try(:total_worked) || Time.current.midnight
  end

  def departure_time
    @departure_time = current_day_record.try(:forecast_departure_time) || Time.current.midnight
  end

  def percentage_worked
    base_time = Time.zone.local(1999, 8, 1).midnight
    time_1 = Time.zone.local(1999, 8, 1).change(hour: workload.hour, min: workload.min)
    time_2 = Time.zone.local(1999, 8, 1).change(hour: total_worked.hour, min: total_worked.min)

    (( (time_2 - base_time) / (time_1 - base_time) ) * 100).round(1)
  end

  private

  def current_day_record
    @current_day_record ||= day_records.where(reference_date: Date.current).first
  end

end
