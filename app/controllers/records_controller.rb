class RecordsController < ApplicationController
  
  before_filter :authenticate_user!

	def index
    @presenter = Records::IndexPresenter.new(Record.new(params[:record]), current_user, params[:page])
	end

  def show
    @record = Record.find(params[:id])
  end

	def new
    @record = Record.new
    @record.time = Time.now
    @record.consider = true
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

    @records = calculate_worked_hours(@record)
    @presenter = Records::ReportPresenter.new(@record, current_user)
  end

  private

  def calculate_worked_hours(record)
    records = Kaminari.paginate_array(Record.month_records(record.time, current_user).all.group_by{ |item| item.time.day }.sort).page(params[:page])    
    
    records.each do |rec|      
      rec.insert(1, Record.sum_total_to_current_time(rec.last, Record.worked_or_lazy_time(rec.second), (rec.last.first.time.to_date == Date.today)))
    end
    
    records
  end

  def calculate_worked_on_month(records)    
    on_month = Time.now
    
    records.each do |rec|
      worked = Record.sum_total_to_current_time(rec.last, Record.worked_or_lazy_time(rec.third), (rec.last.first.time.to_date == Date.today))
      on_month = (on_month + worked.hour.hours) + worked.min.minutes      
    end

    on_month
  end

end
