class Record
  include Mongoid::Document

  field :time, type: Time
  belongs_to :user
  validates_presence_of :time, :user_id

  default_scope -> { asc(:time) }

  scope :today_records, lambda { |time, user|
    asc(:time).
    where(
      time: (time.midnight)..(time.tomorrow.midnight),
      user: user
    )
  }

  def self.calculate_hours(records = [], is_rest = false)
    return Time.current.midnight if records.empty?

    reference_record = records.first
    total_time = reference_record.time.midnight
    condition = is_rest ? 'index.even?' : 'index.odd?'

    records.each_with_index do |record, index|
      diff = Time.diff(reference_record.time, record.time)

      if eval condition
        total_time = (total_time + diff[:hour].hours) + diff[:minute].minutes
      end

      reference_record = record
    end

    if is_rest || !(reference_record.time.today? && records.size.odd?)
      total_time
    else
      now_diff = Time.diff(records.last.time, Time.current)
      (total_time + now_diff[:hour].hours) + now_diff[:minute].minutes
    end

  end

  def self.preview_exit_time(records = [])
    return nil if records.empty?

    rest = calculate_hours(records, true)

    records.first.time + 8.hours + rest.hour.hours + rest.min.minutes
  end

end
