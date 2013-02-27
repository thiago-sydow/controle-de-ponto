class Record
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :time, :type => DateTime
  belongs_to :user

  def self.total_worked_hours(records)
  	@firstRecord = records.first
    @totalHours = Time.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 0, 0)    
    @lastRecord = records.last

    records.each_with_index do |record, index|
      @time_diff_components = Time.diff(Time.parse(@firstRecord.time.to_s), Time.parse(record.time.to_s))

      if index.odd?
        @totalHours += @time_diff_components[:hour].hours
        @totalHours += @time_diff_components[:minute].minutes
      end

      @firstRecord = record
    end
   

    if records.size.odd?
      @diff = Time.diff(Time.parse(@lastRecord.time.to_s), Time.now)
      @totalHours += @diff[:hour].hours
      @totalHours += @diff[:minute].minutes
    end

    @totalHours
  end

end
