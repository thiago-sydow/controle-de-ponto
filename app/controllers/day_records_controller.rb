class DayRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @day_record = DayRecord.new
  end

  def create
    @day_record = DayRecord.new(day_record_params)
    @day_record.user = current_user

    if @day_record.save
      flash[:success] = 'O Registro foi criado com sucesso.'
      redirect_to day_records_path
    else
      flash[:error] = 'Ocorreu um erro ao criar o registro. Por favor tente novamente.'
      render :new
    end

  end

  private

  def day_record_params
    params.require(:day_record).permit!
  end

end
