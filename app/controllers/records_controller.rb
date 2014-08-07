class RecordsController < ApplicationController

  before_action :authenticate_user!

  has_widgets do |root|
    root << widget(:record)
  end


  def index
    @date_to_see = (session[:date_to_see] if session[:date_to_see]) || Date.today
    @records = Record.where(user: current_user, time: (@date_to_see)..(@date_to_see + 1.day))
  end

  def new
    @record = Record.new
    @record.time = session[:date_to_see] unless session[:date_to_see].nil?
  end

  def create
    @record = Record.new(records_params)
    @record.user = current_user

    if @record.save
      redirect_to records_path, success: 'O registro foi criado com sucesso.'
    end

  end

  def edit
    @record = Record.find(records_id_param)
  end

  def update
    @record = Record.find(records_id_param)

    if @record.update_attributes(records_params)
      redirect_to records_path, success: 'O registro foi atualizado com sucesso.'
    else
      render action: 'edit'
    end

  end

  def destroy
    @record = Record.find(records_id_param)
    @record.destroy
    redirect_to records_path, success: 'O registro foi excluído com sucesso.'
  end

  def change_date
    session[:date_to_see] = params[:date_to_see].to_date
    @records = Record.where(user: current_user, time: (session[:date_to_see])..(session[:date_to_see] + 1.day))
    render partial: "records_list", records: @records
  end

  private
  def records_params
    params.require(:record).permit!
  end

  def records_id_param
    params.require(:id)
  end

end