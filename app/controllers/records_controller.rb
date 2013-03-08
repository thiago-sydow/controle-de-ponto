class RecordsController < ApplicationController
  
  before_filter :authenticate_user!

	def index

    @record = Record.new(params[:record])

    if @record.time.nil?      
      @record.time = Time.new    
    end

    @records = Record.asc(:time).where(time: (@record.time.to_date)..(@record.time.to_date + 1.day), user: current_user).page(params[:page])
    @total = Record.sum_total_to_current_time(@records, Record.worked_or_lazy_time(@records), (@record.time.to_date == Date.today))
    @leaving_time = Record.preview_leaving_time(@records.first, Record.worked_or_lazy_time(@records, true)) if @record.time.to_date == Date.today
	end

  def show
    @record = Record.find(params[:id])
  end

	def new
    @record = Record.new
    @record.time = Time.now
  end

  def edit
    @record = Record.find(params[:id])
  end

  def create
    @record = Record.new(params[:record])

    @records = Record.where(time: @record.time, user: current_user).count

    if @records > 0
      redirect_to new_record_path, alert: 'Foi econtrado um registro com os mesmos valores.'
    else
      @record.user = current_user

      if @record.save
        redirect_to records_path, notice: 'O registro foi criado com suceso.'
      end
    end

  end

   def update
    @record = Record.find(params[:id])

    if @record.update_attributes(params[:record])
			redirect_to records_path, notice: 'O registro foi atualizado com sucesso.'
		else
			render action: "edit"
    end

  end

  def destroy
    @record = Record.find(params[:id])
    @record.destroy
    redirect_to records_path
  end

  def monthly_report

    @record = Record.new(params[:record])
    
    @record.time = Time.new unless @record.time

    @records = Kaminari.paginate_array(Record.month_records(@record.time, current_user).
      all.group_by{ |item| item.time.day }.sort).page(params[:page])
    
    on_month = Time.now
    
    @records.each do |record|
      worked = Record.worked_or_lazy_time(record.second)
      on_month = (on_month + worked.hour.hours) + worked.min.minutes
      record.insert(1, worked)
    end

    @total_on_month = Time.diff(on_month, Time.now, '%h horas e %m minutos')
    @should_have_worked = Record.business_days_in_month(@record.time).size * 8

    shoud_have_time = Time.now + @should_have_worked.hours
    
    @credit_debit_hours = Time.diff(shoud_have_time, on_month, '%h horas e %m minutos')
    @credit = on_month > shoud_have_time
  end

end
