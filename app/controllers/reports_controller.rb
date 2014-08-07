class ReportsController < ApplicationController

  def monthly_report
    record = Record.new(params[:record])
    record_time = record.time || Time.new
    @records = Record.month_records(record_time, current_user).all.group_by { |record| record.time.to_date }.sort
  end

end