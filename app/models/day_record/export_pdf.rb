class DayRecord::ExportPdf
  attr_reader :data, :from, :to

  TABLE_HEADER = [
    'Dia',
    'Total',
    'Saldo'
  ]

  def initialize(user, from, to)
    @user = user
    @data = user.day_records.where(reference_date: from..to)
    @from = from.strftime('%d/%m/%Y')
    @to = to.strftime('%d/%m/%Y')
    @header = TABLE_HEADER.dup.insert(1, entrance_exits).flatten
  end

  def generate
    render
    pdf
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

    pdf.text_box "#{from} à #{to}",
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
    data.map do |day|
      text_balance = day.balance.negative? ? '-' : '+'

      rows << [
        day.reference_date.strftime('%d/%m/%Y'),
        day.time_records.collect(&:time).map { |time| time.to_s(:time) },
        day.total_worked.to_s(:time),
        { content: "#{text_balance} #{day.balance.to_s}", background_color: day.balance.negative? ? 'f7ecf2' : 'dff0d8' }
      ].flatten

      rows << [ { content: "       Observações: #{day.observations}", colspan: @header.size } ] unless day.observations.blank?
    end

    rows
  end

  def entrance_exits
    headers = []

    DayRecord.max_time_count_for_user(@user).times do |index|
      headers << h.get_time_label_from_number(index)
    end

    headers
  end

  def h
    ApplicationController.helpers
  end
end
