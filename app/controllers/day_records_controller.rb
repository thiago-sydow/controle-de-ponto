class DayRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @day_records = current_user.day_records.where(reference_date: from..to)
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

  def from
    date_param(params[:from], 30.days.ago)
  end

  def to
    return Date.current unless params[:to]
    Time.zone.parse(params[:to]).to_date || Date.current
  end

  def date_param(param, default = Date.current)
    return default unless param
    Time.zone.parse(param).to_date
  rescue ArgumentError
    default
  end

end
