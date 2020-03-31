module CltWorkerAccountManipulable
  extend ActiveSupport::Concern

  def clt_manipulate_balance(balance, allowance_time)

    if allowance_time
      balance.reset if balance.negative? && balance.to_seconds <= allowance_time
    end

    balance.reset if medical_certificate.yes?
  end

  def clt_manipulate_over_diff(diff, worked_hours, index)
    check_straight_hours_violation(diff) if worked_hours && index.odd?
  end

  def add_lunch_time(time)
    return time unless account.lunch_time && time_records.size < 3
    [time, account.lunch_time].sum
  end

  def forecast_departure_time
    return ZERO_HOUR if !reference_date.today? || time_records.empty?
    rest = calculate_hours(false)

    add_lunch_time([time_records.first.time, account.workload, rest].sum)
  end

  def labor_laws_violations
    @violations ||= check_labor_laws_violations
  end

  def check_labor_laws_violations
    {
      overtime: check_overtime_violation,
      straight_hours: @straight_violation
    }
  end

  def check_straight_hours_violation(diff)
    return false unless account.warn_straight_hours
    @straight_violation = (diff[:hour].hours + diff[:minute].minutes) > 6.hours
  end

  def check_overtime_violation
    return false unless account.warn_overtime
    total_worked > overtime_duration_limit
  end

  def overtime_duration_limit
    (account.workload + 2.hours)
  end

end
