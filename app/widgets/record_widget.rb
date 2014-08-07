class RecordWidget < Apotomo::Widget
  include Devise::Controllers::Helpers

  helper_method :current_user

  responds_to_event :total_worked_hours, with: :total_worked_hours
  responds_to_event :remaining_hours, with: :remaining_hours

  def total_worked_hours
    date = (session[:date_to_see] if session[:date_to_see]) || Date.today
    records = Record.where(time: (date)..(date + 1.day), user: current_user)
    @total = Record.total_worked_hours(records)
    render
  end

  def remaining_hours
    date = (session[:date_to_see] if session[:date_to_see]) || Date.today
    records = Record.where(time: (date)..(date + 1.day), user: current_user)
    total_worked = Record.total_worked_hours(records)
    @total = Time.at((8.hours - total_worked.hour.hours) - total_worked.min.minutes).utc.strftime("%H:%M:%S").to_time
    render
  end

end
