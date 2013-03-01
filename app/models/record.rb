class Record
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :time, :type => DateTime
  belongs_to :user

  def self.total_worked_hours(records)
  	@previousRecord = records.first
    @totalHours = Time.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 0, 0)    

    records.each_with_index do |record, index|
      @time_diff_components = Time.diff(Time.parse(@previousRecord.time.to_s), Time.parse(record.time.to_s))

      if index.odd?
        @totalHours += @time_diff_components[:hour].hours
        @totalHours += @time_diff_components[:minute].minutes
      end

      @previousRecord = record
    end
    
    @totalHours
  end

  def self.sum_total_to_current_time(records, totalHours)
    
    if records.size.odd?
      @diff = Time.diff(Time.parse(records.last.time.to_s), Time.now)
      totalHours += @diff[:hour].hours
      totalHours += @diff[:minute].minutes
    end

    totalHours
  end

  def self.preview_leaving_time(entrance_record, lazy_time)

    if entrance_record.blank?
      0
    else
      @leaving_time = entrance_record.time + 8.hours
      @leaving_time += lazy_time.hour.hours
      @leaving_time += lazy_time.min.minutes
    end
    
  end

  def self.lazy_time(records)
    @first_record = records.first
    @lazy_time = Time.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 0, 0)

    records.each_with_index do |record, index|
      @time_diff_components = Time.diff(Time.parse(@first_record.time.to_s), Time.parse(record.time.to_s))

      if index.even?
        @lazy_time += @time_diff_components[:hour].hours
        @lazy_time += @time_diff_components[:minute].minutes
      end

      @first_record = record
    end
    
    @lazy_time
  end

end
