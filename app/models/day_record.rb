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
    @balance.calculate_balance(user.workload, total_worked)
    @balance
  end

  private

  def calculate_total_worked_hours
    return ZERO_HOUR if time_records.empty?

    total_worked = ZERO_HOUR

    reference_time = time_records.first
    time_records.each_with_index do |time_record, index|
      diff = Time.diff(reference_time.time, time_record.time)

      if index.odd?
        total_worked = (total_worked + diff[:hour].hours) + diff[:minute].minutes
      end

      reference_time = time_record
    end

    if reference_date.today? && time_records.size.odd?
      now_diff = Time.diff(reference_time.time, Time.current)
      total_worked = (total_worked + now_diff[:hour].hours) + now_diff[:minute].minutes
    end

    total_worked
  end

end
