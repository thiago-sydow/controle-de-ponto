class DashboardPresenter < Burgundy::Item

  def total_balance
    @total_balance ||= days_since_last_closure.inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
  end

  def total_worked
    @total_worked ||= current_day_record.try(:total_worked) || DayRecord::ZERO_HOUR
  end

  def departure_time
    @departure_time = current_day_record.try(:forecast_departure_time) || DayRecord::ZERO_HOUR
  end

  def percentage_worked
    base_time = DayRecord::ZERO_HOUR
    time_1 = base_time.change(hour: workload.hour, min: workload.min)
    time_2 = base_time.change(hour: total_worked.hour, min: total_worked.min)

    (( (time_2 - base_time) / (time_1 - base_time) ) * 100).round(1)
  end

  def next_entrance_time
    return nil unless current_day_record
    return nil if current_day_record.time_records.size < 1 
    current_day_record.time_records.last.time + 11.hours
  end

  private

  def current_day_record
    @current_day_record ||= day_records.where(reference_date: Date.current).first
  end

  def days_since_last_closure
    return day_records unless closures.last
    day_records.where(:reference_date.gt => closures.last.end_date)
  end

end
