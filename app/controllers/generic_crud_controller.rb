class GenericCrudController < ApplicationController
  include BeforeRender

  before_action :authenticate_user!

  before_render :set_dashboard

  def set_dashboard
    return nil unless current_user
    @dashboard ||= DashboardPresenter.new(current_user.current_account)
  end

  protected

  def create
    get_instance_variable.account = current_user.current_account

    if get_instance_variable.save
      flash[:success] =  t "#{controller_name}.create.success"
      redirect_to  action: :index
    else
      flash[:error] = t "#{controller_name}.create.error"
      render :new
    end

  end

  def update

    if get_instance_variable.update_attributes(model_params)
      flash[:success] = t "#{controller_name}.update.success"
      redirect_to action: :index
    else
      flash[:error] = t "#{controller_name}.update.error"
      render :edit
    end

  end

  def destroy
    get_instance_variable.destroy

    if get_instance_variable.destroyed?
      flash[:success] = t "#{controller_name}.destroy.success"
    else
      flash[:error] = t "#{controller_name}.destroy.error"
    end

    redirect_to action: :index
  end


  private

  def get_instance_variable
    @inst_variable ||= instance_variable_get("@#{controller_name.singularize}")
  end

end
