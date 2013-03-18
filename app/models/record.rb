class Record
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :time, :type => DateTime
  belongs_to :user

  default_scope asc(:time)

  scope :month_records, lambda {|time, user|    
    asc(:time).where(time: (time.at_beginning_of_month)..(time.at_end_of_month + 1.day), user: user)   
  }

  def self.sum_total_to_current_time(records, total_hours, sum_current_time = true)
    
    return total_hours unless records.size.odd? && sum_current_time

    diff = Time.diff(Time.parse(records.last.time.to_s), Time.now)
    total_hours = (total_hours + diff[:hour].hours) + diff[:minute].minutes
  end

  def self.preview_leaving_time(entrance_record, lazy_time)
    @leaving_time = entrance_record.blank? ? 0 : ((entrance_record.time + 8.hours) + lazy_time.hour.hours) + lazy_time.min.minutes
  end

  def self.worked_or_lazy_time(records, lazy = false)
    first_record = records.first
    @total = Time.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 0, 0)
    condition = lazy ? 'index.even?' : 'index.odd?'

    records.each_with_index do |record, index|
      time_diff_components = Time.diff(Time.parse(first_record.time.to_s), Time.parse(record.time.to_s))

      if eval condition
        @total = (@total + time_diff_components[:hour].hours) + time_diff_components[:minute].minutes        
      end

      first_record = record
    end
    
    @total
  end

  def self.business_days_in_month(time)

    range = if time.month == Time.now.month
      (time.at_beginning_of_month)..(Time.now)
    else
      (time.at_beginning_of_month)..(time.at_end_of_month)
    end

    weekdays = range.reject { |d| [0,6].include? d.wday}
  end

end