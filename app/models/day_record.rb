class DayRecord
  include Mongoid::Document
  extend Enumerize

  ZERO_HOUR = Time.current.change(hour: 0, minute: 0)

  field :reference_date, type: Date, default: Date.current
  field :observations, type: String
  field :work_day
  field :missed_day

  enumerize :work_day, in: {yes: 1, no: 0}, default: :yes
  enumerize :missed_day, in: {yes: 1, no: 0}, default: :no

  belongs_to :user
  has_many :time_records, dependent: :delete

  accepts_nested_attributes_for :time_records, reject_if: :all_blank, allow_destroy: true

  validates_uniqueness_of :reference_date, scope: :user_id
  default_scope -> { desc(:reference_date) }

  def work_statistics
    total_worked = ZERO_HOUR

    return total_worked if time_records.empty?

    reference_time = time_records.first
    time_records.each_with_index do |time_record, index|
      diff = Time.diff(reference_time.time, time_record.time)

      if index.odd?
        total_worked = (total_worked + diff[:hour].hours) + diff[:minute].minutes
      end

      reference_time = time_record
    end

    if reference_date.today? && !time_records.size.even?
      now_diff = Time.diff(reference_time.time, Time.current)
      total_worked = (total_worked + now_diff[:hour].hours) + now_diff[:minute].minutes
    end

    balance = ( user.workload - total_worked.hour.hours) - total_worked.min.minutes
    wl = balance.change(hour: user.workload.hour, min: user.workload.min)

    { total_worked: total_worked, balance: balance, positive: wl < balance }
  end

end
