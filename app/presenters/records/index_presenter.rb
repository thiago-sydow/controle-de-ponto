class Records::IndexPresenter
	extend ActiveSupport::Memoizable

	def initialize(record, user, page)
		@record = record
		@record.time = Time.new unless @record.time
    @records = Record.where(time: (get_record.time.to_date)..(get_record.time.to_date + 1.day), user: user).page(page)
	end

	def get_record
		@record
	end

	def get_records
		@records
	end

	def total_time    
    Record.sum_total_to_current_time(@records, Record.worked_or_lazy_time(@records), (get_record.time.to_date == Date.today))    
	end

	def leaving_time
		Record.preview_leaving_time(@records.first, Record.worked_or_lazy_time(@records, true)) if get_record.time.to_date == Date.today
	end

	memoize :get_record, :get_records
end