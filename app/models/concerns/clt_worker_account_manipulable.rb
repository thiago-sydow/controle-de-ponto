module CltWorkerAccountManipulable
  extend ActiveSupport::Concern

  def clt_manipulate_balance(balance)
    return unless account.allowance_time
    allowance = (account.allowance_time.hour.hours + account.allowance_time.min.minutes)
    balance.reset if balance.to_seconds <= allowance
  end

  def clt_manipulate_over_diff(diff, worked_hours, index)
    check_straight_hours_violation(diff) if worked_hours && index.odd?
  end

  def add_lunch_time(time)
    return time unless account.lunch_time
    return time unless time_records.size < 3

    sum_times(time, account.lunch_time)
  end

  def forecast_departure_time
    return ZERO_HOUR if time_records.empty? || !reference_date.today?
    rest = calculate_hours(false)

    add_lunch_time(sum_times(time_records.first.time, account.workload, rest))
  end

  def labor_laws_violations
    @violations ||= check_labor_laws_violations
  end

  def check_labor_laws_violations
    {
      overtime: check_overtime_violation,
      straight_hours: @straight_hours_violation
    }
  end

  def check_straight_hours_violation(diff)
    return false unless account.warn_straight_hours
    @straight_hours_violation ||= (diff[:hour].hours + diff[:minute].minutes) > 6.hours
  end

  def check_overtime_violation
    return false unless account.warn_overtime
    total_worked_duration > overtime_duration_limit
  end

  def total_worked_duration
    (total_worked.hour.hours + total_worked.min.minutes)
  end

  def overtime_duration_limit
    (account.workload.hour.hours + account.workload.min.minutes + 2.hours)
  end

end
