class ClosuresController < GenericCrudController

  before_action :find_closure, only: [:edit, :update, :destroy]

  def index
    @closures = current_user.current_account.closures.page params[:page]
  end

  def new
    @closure = Closure.new
    @closure.start_date = (Date.current - 3.months)
    @closure.end_date = Date.current
  end

  def create
    @closure = Closure.new(model_params)
    super
  end

  def edit
  end

  def update
    super
  end

  def destroy
    super
  end

  private

  def find_closure
    @closure = Closure.find(closure_id_param)
  end

  def closure_id_param
    params.require(:id)
  end

  def model_params
    params.require(:closure).permit(:start_date, :end_date)
  end

end
