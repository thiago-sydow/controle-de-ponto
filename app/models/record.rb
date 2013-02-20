class Record
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :time, :type => DateTime
  belongs_to :user

  def self.total_worked_hours(records)
  	@firstRecord = records.first
    @totalHours = 0
    @totalMinutes = 0

    records.each_with_index do |record, index|
      @time_diff_components = Time.diff(Time.parse(@firstRecord.time.to_s), Time.parse(record.time.to_s))

      if index.odd?
        @totalHours += @time_diff_components[:hour]
        @totalMinutes += @time_diff_components[:minute]
      end

      @firstRecord = record
    end

    @total_hours = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, @totalHours, @totalMinutes)
  end

end
