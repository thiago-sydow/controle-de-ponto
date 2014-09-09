class Record
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Enum

  field :time, type: DateTime
  enum :record_type, [:normal, :extra_hour], default: :normal
  belongs_to :user


  default_scope -> { asc(:time) }

  scope :month_records, lambda { |time, user|
    asc(:time).where(time: (time.at_beginning_of_month)..(time.at_end_of_month + 1.day), user: user)
  }

  def self.total_worked_hours(records)

    return Time.new.midnight if records.empty?

    reference_record = records.first
    total_time = reference_record.time.midnight

    records.each_with_index do |record, index|
      time_diff = Time.diff(Time.parse(reference_record.time.to_s), Time.parse(record.time.to_s))

      if index.odd?
        total_time = (total_time + time_diff[:hour].hours) + time_diff[:minute].minutes
      end

      reference_record = record
    end

    return total_time unless reference_record.time.today? && records.size.odd?

    now_diff = Time.diff(Time.parse(records.last.time.to_s), Time.now)

    (total_time + now_diff[:hour].hours) + now_diff[:minute].minutes
  end

  def self.preview_remaining_time(records)
    records.first.nil? ? 0 : ((records.first.time + 8.hours) + lazy_time.hour.hours) + lazy_time.min.minutes
  end

end