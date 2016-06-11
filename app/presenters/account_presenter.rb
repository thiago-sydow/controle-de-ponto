class AccountPresenter < Burgundy::Item

  def total_balance
    @total_balance ||= days_since_closure.inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
  end

  def total_worked
    return ZERO_HOUR unless current_day_record
    @total_worked ||= current_day_record.total_worked
  end

  def departure_time
    return nil unless current_day_record
    @departure_time = current_day_record.forecast_departure_time
  end

  def percentage_worked
    return 0 unless current_day_record
    ((total_worked.to_f / workload.to_f) * 100).round(1)
  end

  def next_entrance_time
    return nil unless current_day_record
    return nil unless current_day_record.time_records.exists?
    current_day_record.time_records.last.time + 11.hours
  end

  def total_earned
    return 0 unless hourly_rate.to_i > 0
    @total_earned ||= calculate_earns
  end

  private

  def current_day_record
    return @current_day_record unless @current_day_record.nil?
    @current_day_record = day_records.today.first || false
  end

  def days_since_closure
    @days ||= if closures.exists?
                day_records.includes(:time_records).where('reference_date >= ?', closures.first.end_date)
              else
                day_records.includes(:time_records)
              end
  end

  def calculate_earns
    days_since_closure.inject(0) { |sum, day| get_earns_sum(sum, day) }.to_f
  end

  def get_earns_sum(sum, day)
    earns_by_second = BigDecimal.new(hourly_rate.to_s) / 3600
    sum + (earns_by_second * day.total_worked)
  end

end
