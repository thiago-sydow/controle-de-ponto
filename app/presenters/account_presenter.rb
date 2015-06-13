class AccountPresenter < Burgundy::Item

  def total_balance
    @total_balance ||= days_since_closure.inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
  end

  def total_worked
    return ZERO_HOUR unless current_day_record
    @total_worked ||= current_day_record.total_worked
  end

  def departure_time
    return ZERO_HOUR unless current_day_record
    @departure_time = current_day_record.forecast_departure_time
  end

  def percentage_worked
    return 0 unless current_day_record

    base_time = ZERO_HOUR
    time_1 = base_time.change(hour: workload.hour, min: workload.min)
    time_2 = base_time.change(hour: total_worked.hour, min: total_worked.min)

    (((time_2 - base_time) / (time_1 - base_time)) * 100).round(1)
  end

  def next_entrance_time
    return nil unless current_day_record
    return nil unless current_day_record.time_records.exists?
    current_day_record.time_records.last.time + 11.hours
  end

  def total_earned
    return 0 unless hourly_rate > 0
    @total_earned ||= calculate_earns
  end

  private

  def current_day_record
    return @current_day_record unless @current_day_record.nil?
    @current_day_record = day_records.today.first || false
  end

  def days_since_closure
    @days ||= if closures.exists?
                day_records.where(:reference_date.gt => closures.last.end_date)
              else
                day_records
              end
  end

  def calculate_earns
    days_since_closure.inject(0) { |sum, day| get_earns_sum(sum, day) }
  end

  def get_earns_sum(sum, day)
    earns_by_second = hourly_rate / 3600
    total_seconds = day.total_worked.hour.hours + day.total_worked.min.minutes
    sum + (earns_by_second * total_seconds)
  end

end