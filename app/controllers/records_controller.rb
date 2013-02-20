class RecordsController < ApplicationController
  
  before_filter :authenticate_user!

	def index
		@records = Record.asc(:time).where(time: (Date.today)..(Date.today + 1.day)).page(params[:page])
    @total = Record.total_worked_hours(@records)
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
    
    @record.user = current_user

    if @record.save
    	redirect_to records_path, notice: 'O registro foi criado com suceso.'
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

end
