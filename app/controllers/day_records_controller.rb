class DayRecordsController < GenericCrudController

  before_action :find_record, only: [:edit, :update, :destroy]
  before_action :set_date_range, only: [:index]

  def index
    @day_records = current_user.day_records.where(reference_date: from..to).page params[:page]
    @balance_period = @day_records.inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
    @max_time_records = DayRecord.max_time_count_for_user(current_user)
  end

  def new
    @day_record = DayRecord.new
    @day_record.time_records.build
  end

  def create
    @day_record = DayRecord.new(model_params)
    super
  end

  def edit
    @day_record.time_records.build if @day_record.time_records.empty?
  end

  def update
    super
  end

  def destroy
    super
  end

  def async_worked_time
    render json: { time: @dashboard.total_worked.to_s(:time), percentage: @dashboard.percentage_worked }
  end

  private

  def set_date_range
    @from = from
    @to = to
  end

  def find_record
    @day_record = DayRecord.find(day_record_id_param)
  end

  def day_record_id_param
    params.require(:id)
  end

  def model_params
    params.require(:day_record).
    permit(
      :reference_date, :observations, :work_day, :missed_day,
      time_records_attributes: [:id, :time, :_destroy]
      )
  end

  def from
    date_param(params[:from], 30.days.ago)
  end

  def to
    date_param(params[:to])
  end

  def date_param(param, default = Date.current)
    return default if param.blank?
    Time.zone.parse(param).to_date
  rescue ArgumentError
    Rollbar.warning('Formato invalido de data')
    default
  end

end
