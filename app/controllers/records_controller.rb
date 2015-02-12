class RecordsController < ApplicationController
  before_action :authenticate_user!

  before_action :find_record, only: [:edit, :update, :destroy]

  def index
    @records = Record.today_records(Time.current, current_user)
    @total_time = Record.worked_hours(@records)
  end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    @record.user = current_user

    if @record.save
      flash[:success] = 'O registro foi criado com sucesso.'
      redirect_to records_path
    else
      flash[:error] = 'Um erro ocorreu ao criar o registro.'
      render :new
    end

  end

  def edit
  end

  def update

    if @record.update_attributes(record_params)
      flash[:success] = 'O registro foi atualizado com sucesso.'
      redirect_to records_path
    else
      flash[:error] = 'Um erro ocorreu ao atualizar o registro.'
      render action: 'edit'
    end
  end

  def destroy
    @record.destroy

    if @record.destroyed?
      flash[:success] = 'O registro foi excluído com sucesso.'
    else
      flash[:error] = 'Um erro ocorreu ao excluir o registro.'
    end

    redirect_to records_path
  end

  private

  def find_record
    @record = Record.find(record_id_param)
  end

  def record_params
    params.require(:record).permit!
  end

  def record_id_param
    params.require(:id)
  end

end
