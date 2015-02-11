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

  def self.worked_hours(records = [])
    return Time.current.midnight if records.empty?

    reference_record = records.first
    total_time = reference_record.time.midnight

    records.each_with_index do |record, index|
      time_diff = Time.diff(reference_record.time, record.time)

      if index.odd?
        total_time = (total_time + time_diff[:hour].hours) + time_diff[:minute].minutes
      end

      reference_record = record
    end

    return total_time unless reference_record.time.today? && records.size.odd?

    now_diff = Time.diff(records.last.time, Time.current)

    (total_time + now_diff[:hour].hours) + now_diff[:minute].minutes
  end

end
