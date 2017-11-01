class DayRecordsController < GenericCrudController
  include ApplicationHelper

  before_action :find_record, only: [:edit, :update, :destroy]
  before_action :set_date_range, only: [:index, :export]

  def index
    all_records = current_account.day_records.includes(:time_records).date_range(@from, @to)
    @day_records = all_records.page params[:page]
    @balance_period = all_records.inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
    @max_time_records = DayRecord.max_time_count_for_account(current_account)
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
    @day_record.time_records.build unless @day_record.time_records.exists?
  end

  def update
    super
  end

  def destroy
    super
  end

  def async_worked_time
    set_presenter
    render json: { time: format_seconds_to_time(@account_presenter.total_worked), percentage: @account_presenter.percentage_worked }
  end

  def export

    case export_format_param
    when 'xlsx'
      file_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      file = DayRecord::ExportSheet.new(current_account, @from, @to)
    else
      file_type = 'application/pdf'
      file = DayRecord::ExportPdf.new(current_account, @from, @to)
    end

    send_data file.generate,
      filename: "#{current_user.first_name} - #{current_user.current_account.name} - #{@from.strftime('%d/%m/%Y')} à #{@to.strftime('%d/%m/%Y')}.#{export_format_param}",
      type: file_type
  end

  def add_now
    current_day = current_account.day_records.today.first_or_create
    current_day.time_records.create(time: Time.current)
    flash[:success] =  t "day_records.create.success"

    redirect_to action: :index
  end

  private

  def current_account
    @acc ||= current_user.current_account
  end

  def export_format_param
    params.require(:format)
  end

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
      :reference_date, :observations, :work_day, :missed_day, :medical_certificate,
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
