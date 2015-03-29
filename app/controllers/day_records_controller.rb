class DayRecordsController < ApplicationController
  before_action :authenticate_user!

  before_action :find_record, only: [:edit, :update, :destroy]

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

  def edit
  end

  def update

    if @day_record.update_attributes(day_record_params)
      flash[:success] = 'O registro foi atualizado com sucesso.'
      redirect_to day_records_path
    else
      flash[:error] = 'Um erro ocorreu ao atualizar o registro.'
      render action: 'edit'
    end

  end

  def destroy
    @day_record.destroy

    if @day_record.destroyed?
      flash[:success] = 'O registro foi excluído com sucesso.'
    else
      flash[:error] = 'Um erro ocorreu ao excluir o registro.'
    end

    redirect_to day_records_path
  end

  private

  def find_record
    @day_record = DayRecord.find(day_record_id_param)
  end

  def day_record_id_param
    params.require(:id)
  end

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
