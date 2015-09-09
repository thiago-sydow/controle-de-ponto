class DayRecord
  include Mongoid::Document
  include AccountManipulable
  extend Enumerize

  field :reference_date, type: Date, default: -> { Date.current }
  field :observations, type: String
  field :work_day
  field :missed_day
  field :medical_certificate

  enumerize :work_day, in: { yes: 1, no: 0 }, default: :yes
  enumerize :missed_day, in: { yes: 1, no: 0 }, default: :no
  enumerize :medical_certificate, in: { yes: 1, no: 0 }, default: :no

  belongs_to :account
  embeds_many :time_records

  accepts_nested_attributes_for :time_records, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :reference_date
  validates_uniqueness_of :reference_date, scope: :account_id
  validates :time_records, presence: true, if: :only_work_day?

  validate :future_reference_date

  default_scope -> { desc(:reference_date) }

  scope :today, -> { where(reference_date: Date.current) }
  scope :date_range, -> (from, to) { where(reference_date: from..to) }

  def self.max_time_count_for_account(account)
    where(account: account).map { |day| day.time_records.count }.max || 0
  end

  def total_worked
    @total_worked ||= calculate_total_worked_hours
  end

  def balance
    return @balance if @balance
    @balance = TimeBalance.new

    work_day.yes? ? balance_for_working_day : balance_for_non_working_day

    account_manipulate_balance(@balance)

    @balance
  end

  private

  def sum_times(*times)
    times.inject { |sum, time| sum + time.hour.hours + time.min.minutes }
  end

  def balance_for_working_day
    if missed_day.no?
      @balance.calculate_balance(account.workload, total_worked)
    else
      @balance.calculate_balance(account.workload, ZERO_HOUR)
    end
  end

  def balance_for_non_working_day
    if missed_day.no?
      @balance.calculate_balance(ZERO_HOUR, total_worked)
    else
      @balance.reset
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
      account_manipulate_over_diff(diff, worked_hours, index)
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

  def future_reference_date
    return unless reference_date
    errors.add(:reference_date, :future_date) if reference_date.future?
  end

  def only_work_day?
    work_day.yes? and missed_day.no? and medical_certificate.no?
  end
end
