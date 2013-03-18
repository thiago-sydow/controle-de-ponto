class Records::ReportPresenter
	extend ActiveSupport::Memoizable
	
	def initialize(chosen_time, user)
		
		@record = chosen_time

		on_month = Record.month_records(@record.time, user).all.group_by{ |item| item.time.day }.sort

		@total_on_month = Time.now

		on_month.each do |rec|
			rec.delete_at(0)
			worked = Record.sum_total_to_current_time(rec.last, Record.worked_or_lazy_time(rec.first), (rec.first.last.time.to_date == Date.today))
      @total_on_month = (@total_on_month + worked.hour.hours) + worked.min.minutes
		end

	end
	
	def total_on_month
		Time.diff(@total_on_month, Time.now, '%h horas e %m minutos')[:diff]
	end

	def should_have_worked
		Record.business_days_in_month(@record.time).size * 8		
	end

	def credit_debit_hours
		should_have_time = Time.now + should_have_worked.hours
		{credit_or_debit: (@total_on_month > should_have_time), total: Time.diff(should_have_time, @total_on_month, '%h horas e %m minutos')[:diff]}
	end

	memoize :credit_debit_hours

end