class DayRecord::ExportSheet < DayRecord::BaseExport

  def generate
    sheet
    render
    @sheet.to_stream.read
  end

  private

  def render
    @sheet.workbook.add_worksheet(name: "Registros") do |sheet|
      page_header(sheet)
      reports_list(sheet)
    end
  end

  def sheet
    @sheet ||= Axlsx::Package.new
    @sheet.use_shared_strings = true
  end

  def page_header(sheet)
    sheet.add_row @header << 'Observações'
  end

  def reports_list(sheet)
    balance_sum = parse_days(sheet)
    mount_sum_row(sheet, balance_sum)
  end

  def parse_days(sheet)
    balance_sum = TimeBalance.new
    
    data.each do |day|
      balance_sum.sum(day.balance)
      sheet.add_row mount_day_row(day)
    end

    balance_sum
  end

  def mount_day_row(day)
    text_balance = day.balance.negative? ? '-' : '+'
    times = day.time_records.collect(&:time).map { |time| time.to_s(:time) }
    times.fill('', (times.size)..(@header.size - 5))

    [
      day.reference_date.strftime('%d/%m/%Y'),
      times,
      h.format_seconds_to_time(day.total_worked),
      "#{text_balance} #{day.balance.to_s}",
      day.observations.to_s
    ].flatten
  end

  def mount_sum_row(sheet, balance_sum)
    text_balance = balance_sum.negative? ? '-' : '+'
    sum_row = ['Saldo Total']
    sum_row.fill('', (1)..(@header.size - 1))
    sum_row[-2] = "#{text_balance} #{balance_sum.to_s}"
    sheet.add_row sum_row
  end

end
