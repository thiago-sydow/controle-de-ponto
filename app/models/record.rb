class Record
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Enum

  GROUP_TYPE_NONE = 0
  GROUP_TYPE_QUARTER = 3
  GROUP_TYPE_FOUR_MONTHS = 4
  GROUP_TYPE_SEMIANNUAL = 6

  field :time, type: DateTime
  enum :record_type, [:normal, :extra_hour], default: :normal
  belongs_to :user

  default_scope -> { asc(:time) }

  scope :month_records, lambda { |time, user|
    asc(:time).where(time: (time.at_beginning_of_month)..(time.at_end_of_month + 1.day), user: user)
  }

  scope :year_records, lambda { |time, user|
    asc(:time).where(time: (time.at_beginning_of_year)..(time.at_end_of_year + 1.day), user: user)
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

  def self.get_year_grouped_records(time, user, group_type)
    @records = group_records_by_type(time.year, user, GROUP_TYPE_QUARTER)
    asd
  end

  private

  def self.group_records_by_type(year, user, group_type)

    grouped_records = {}

    case group_type
      when GROUP_TYPE_QUARTER
        [1,4,7,10].each_with_index do |item,index|
          grouped_records[index + 1] = asc(:time)
            .where(time: ((Time.new(year,item).at_beginning_of_month)..(Time.new(year,item+2).at_end_of_month + 1.day)), user: user).to_a
        end
      when GROUP_TYPE_FOUR_MONTHS
        [1,5,9].each_with_index do |item, index|
           grouped_records[index + 1] = asc(:time)
            .where(time: ((Time.new(year,item).at_beginning_of_month)..(Time.new(year,item+3).at_end_of_month + 1.day)), user: user).to_a
        end
      when GROUP_TYPE_SEMIANNUAL
        [1,7].each_with_index do |item, index|
          grouped_records[index + 1] = asc(:time)
            .where(time: ((Time.new(year,item).at_beginning_of_month)..(Time.new(year,item+5).at_end_of_month + 1.day)), user: user).to_a
        end
      else

    end

    grouped_records
  end



end
