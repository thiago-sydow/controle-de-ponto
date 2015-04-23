class ClosuresController < ApplicationController
  before_action :authenticate_user!

  before_action :find_closure, only: [:edit, :update, :destroy]
  #before_action :set_date_range, only: [:index]
  before_action :set_dashboard, except: [:update, :destroy, :create]

  def index
    @closures = current_user.closures.page params[:page]
  end

  def new
    @closure = Closure.new
    @closure.start_date = (Date.current - 3.months)
    @closure.end_date = Date.current
  end

  def create
    @closure = Closure.new(closure_params)
    @closure.user = current_user

    if @closure.save
      flash[:success] = 'O Fechamento foi criado com sucesso.'
      redirect_to closures_path
    else
      flash[:error] = 'Ocorreu um erro ao criar o Fechamento. Por favor tente novamente.'
      render :new
    end

  end

  def edit
  end

  def update

    if @closure.update_attributes(closure_params)
      flash[:success] = 'O Fechamento foi atualizado com sucesso.'
      redirect_to closures_path
    else
      flash[:error] = 'Um erro ocorreu ao atualizar o Fechamento.'
      render action: :edit
    end

  end

  def destroy
    @closure.destroy

    if @closure.destroyed?
      flash[:success] = 'O Fechamento foi excluído com sucesso.'
    else
      flash[:error] = 'Um erro ocorreu ao excluir o Fechamento.'
    end

    redirect_to closures_path
  end

  private

  def set_dashboard
    @dashboard ||= DashboardPresenter.new(current_user)
  end

  def find_closure
    @closure = Closure.find(closure_id_param)
  end

  def closure_id_param
    params.require(:id)
  end

  def closure_params
    params.require(:closure).permit(:start_date, :end_date)
  end
  
end
