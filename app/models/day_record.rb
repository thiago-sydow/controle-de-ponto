class DayRecord
  include Mongoid::Document
  extend Enumerize

  ZERO_HOUR = Time.zone.local(1999, 8, 1).change(hour: 0, minute: 0)

  field :reference_date, type: Date, default: -> { Date.current }
  field :observations, type: String
  field :work_day
  field :missed_day

  enumerize :work_day, in: { yes: 1, no: 0 }, default: :yes
  enumerize :missed_day, in: { yes: 1, no: 0 }, default: :no

  belongs_to :user
  embeds_many :time_records

  accepts_nested_attributes_for :time_records, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :reference_date
  validates_uniqueness_of :reference_date, scope: :user_id

  validate :future_reference_date

  default_scope -> { desc(:reference_date) }

  def self.max_time_count_for_user(user)
    where(user: user).map { |day| day.time_records.count }.max || 0
  end

  def total_worked
    @total_worked ||= calculate_total_worked_hours
  end

  def balance
    return @balance if @balance
    @balance = TimeBalance.new

    work_day.yes? ? balance_for_working_day : balance_for_non_working_day

    @balance
  end

  def forecast_departure_time
    return ZERO_HOUR if time_records.empty? || !reference_date.today?
    rest = calculate_hours(false)

    add_lunch_time(sum_times(time_records.first.time, user.workload, rest))
  end

  def labor_laws_violations
    @violations ||= check_labor_laws_violations
  end

  private

  def check_labor_laws_violations
    {
      overtime: check_overtime_violation,
      straight_hours: @straight_hours_violation
    }
  end

  def sum_times(*times)
    times.inject { |sum, time| sum + time.hour.hours + time.min.minutes }
  end

  def add_lunch_time(time)
    return time unless user.lunch_time
    return time unless time_records.size < 3

    sum_times(time, user.lunch_time)
  end

  def balance_for_working_day
    if missed_day.no?
      @balance.calculate_balance(user.workload, total_worked)
    else
      @balance.calculate_balance(user.workload, ZERO_HOUR)
    end
  end

  def balance_for_non_working_day
    if missed_day.no?
      @balance.calculate_balance(ZERO_HOUR, total_worked)
    else
      @balance.calculate_balance(ZERO_HOUR, ZERO_HOUR)
    end
  end

  def calculate_total_worked_hours
    return ZERO_HOUR if time_records.empty?

    sum_current_time_to_total(time_records.last.time, calculate_hours)
  end

  def calculate_hours(worked_hours = true)
    total = ZERO_HOUR

    reference_time = time_records.first

    time_records.each_with_index do |time_record, index|
      diff = Time.diff(reference_time.time, time_record.time)
      total = total + diff[:hour].hours + diff[:minute].minutes if satisfy_conditions(worked_hours, index)
      check_straight_hours_violation(diff) if worked_hours && index.odd?
      reference_time = time_record
    end

    total
  end

  def satisfy_conditions(worked, record_index)
    return true if worked && record_index.odd?
    return true if !worked && record_index.even?
    false
  end

  def sum_current_time_to_total(last_time_record, total)
    return total unless reference_date.today? && time_records.size.odd?

    now_diff = Time.diff(last_time_record, Time.current)
    (total + now_diff[:hour].hours) + now_diff[:minute].minutes
  end

  def check_straight_hours_violation(diff)
    return false unless user.warn_straight_hours
    @straight_hours_violation = @straight_hours_violation || (diff[:hour].hours + diff[:minute].minutes) > 6.hours
  end

  def check_overtime_violation
    return false unless user.warn_overtime
    (total_worked.hour.hours + total_worked.min.minutes) > (user.workload.hour.hours + user.workload.min.minutes + 2.hours)
  end

  def future_reference_date
    errors.add(:reference_date, :future_date) if reference_date.future?
  end

end
