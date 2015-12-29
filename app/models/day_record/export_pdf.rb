class DayRecord::ExportPdf < DayRecord::BaseExport

  def generate
    pdf
    render
    @pdf.render
  end

  private

  def render
    page_header
    reports_list
  end

  def pdf
    @pdf ||= Prawn::Document.new(page_size: 'A4', page_layout: :landscape, margin: [30, 30, 30, 30])
  end

  def page_header
    pdf.text 'Meu Controle de Ponto',
    size: 25,
    align: :left,
    inline_format: true,
    color: '438eb9'

    pdf.text 'www.meucontroledeponto.com.br | Controle suas horas trabalhadas',
    size: 10,
    align: :left,
    inline_format: true,
    style: :italic

    pdf.text_box "#{@account.name}\n#{from} à #{to}",
    size: 12,
    style: :bold,
    align: :right,
    inline_format: true,
    at: [2, 510]
  end

  def reports_list
    pdf.move_down 20
    options = {
      width: 782,
      row_colors: %w(f5f5f5 FFFFFF),
      header: true
    }

    pdf.table([@header, *table_rows], options) do
      row(0).font_style = :bold
      row(0).background_color = '777777'
      row(0).text_color = 'FFFFFF'
    end
  end

  def table_rows
    rows = []
    balance_sum = TimeBalance.new

    data.map do |day|
      text_balance = day.balance.negative? ? '-' : '+'
      times = day.time_records.collect(&:time).map { |time| time.to_s(:time) }
      times.fill('', (times.size)..(@header.size - 4))

      rows << [
        day.reference_date.strftime('%d/%m/%Y'),
        times,
        h.format_seconds_to_time(day.total_worked),
        { content: "#{text_balance} #{day.balance.to_s}", background_color: day.balance.negative? ? 'f7ecf2' : 'dff0d8' }
      ].flatten

      rows << [ { content: "       Observações: #{day.observations}", colspan: @header.size } ] unless day.observations.blank?

      balance_sum.sum(day.balance)
    end


    text_balance = balance_sum.negative? ? '-' : '+'
    sum_row = [
      { content: "Saldo Total", colspan: @header.size - 1, font_style: :bold },
      { content: "#{text_balance} #{balance_sum.to_s}", background_color: balance_sum.negative? ? 'f7ecf2' : 'dff0d8', font_style: :bold }
    ]

    rows << sum_row
    rows
  end

end
