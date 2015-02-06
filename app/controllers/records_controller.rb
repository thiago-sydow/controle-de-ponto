class RecordsController < ApplicationController
  before_action :authenticate_user!

  before_action :find_record, only: [:edit, :update, :destroy]

  def index
    @records = Record.where(time: (Time.current.midnight)..(Time.current.tomorrow.midnight),
                            user: current_user)
  end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    @record.user = current_user

    if @record.save
      redirect_to records_path, success: 'O registro foi criado com sucesso.'
    end

  end

  def edit
  end

  def update
    if @record.update_attributes(record_params)
      redirect_to records_path, success: 'O registro foi atualizado com sucesso.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @record.destroy
    redirect_to records_path, success: 'O registro foi excluído com sucesso.'
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
