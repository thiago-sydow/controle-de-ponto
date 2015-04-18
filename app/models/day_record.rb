class DayRecord
  include Mongoid::Document
  extend Enumerize

  ZERO_HOUR = Time.zone.local(1999, 8, 1).change(hour: 0, minute: 0)

  field :reference_date, type: Date, default: Date.current
  field :observations, type: String
  field :work_day
  field :missed_day

  enumerize :work_day, in: {yes: 1, no: 0}, default: :yes
  enumerize :missed_day, in: {yes: 1, no: 0}, default: :no

  belongs_to :user
  embeds_many :time_records

  accepts_nested_attributes_for :time_records, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :reference_date
  validates_uniqueness_of :reference_date, scope: :user_id

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

    if work_day.yes?
      balance_for_working_day
    else
      balance_for_non_working_day
    end

    @balance
  end

  def forecast_departure_time
    return ZERO_HOUR if time_records.empty? || !reference_date.today?
    rest = calculate_hours(false)
    departure_time = time_records.first.time + user.workload.hour.hours + user.workload.min.minutes + rest.hour.hours + rest.min.minutes

    return departure_time unless user.lunch_time
    return departure_time unless time_records.size < 3

    departure_time + user.lunch_time.hour.hours + user.lunch_time.min.minutes
  end

  private

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

    total_worked = calculate_hours

    sum_current_time_to_total(time_records.last.time, total_worked)
  end

  def calculate_hours(worked_hours = true)
    total = ZERO_HOUR

    reference_time = time_records.first

    time_records.each_with_index do |time_record, index|
      diff = Time.diff(reference_time.time, time_record.time)

      if worked_hours
        total = (total + diff[:hour].hours) + diff[:minute].minutes if index.odd?
      else
        total = (total + diff[:hour].hours) + diff[:minute].minutes if index.even?
      end

      reference_time = time_record
    end

    total
  end

  def sum_current_time_to_total(last_time_record, total)
    return total unless reference_date.today? && time_records.size.odd?

    now_diff = Time.diff(last_time_record, Time.current)
    (total + now_diff[:hour].hours) + now_diff[:minute].minutes
  end

end
