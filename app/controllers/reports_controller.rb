class ReportsController < ApplicationController

  has_widgets do |root|
    root << widget(:record)
  end

  def monthly_report
    record = Record.new(params[:record])
    record_time = record.time || Time.new
    @records = Record.month_records(record_time, current_user).all.group_by { |record| record.time.to_date }.sort
  end

  def full_report
    year = params[:year].nil? ? Time.now : Time.new(params[:year])
    group_type = params[:group_type] || Record::GROUP_TYPE_NONE
    @records = Record.get_year_grouped_records(year, current_user, group_type)
  end

end
