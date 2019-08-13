class DayRecord::BaseExport
  attr_reader :data, :from, :to

  TABLE_HEADER = [
    'Dia',
    'Total',
    'Saldo'
  ]

  def initialize(account, from, to)
    @account = account
    @data = account.day_records.includes(:time_records).where(reference_date: from..to)
    @from = from.strftime('%d/%m/%Y')
    @to = to.strftime('%d/%m/%Y')
    @dynamic_headers = entrance_exits
    @header = TABLE_HEADER.dup.insert(1, @dynamic_headers).flatten
  end

  def generate

  end

  protected

  def entrance_exits
    headers = []

    TimeRecord.max_time_count(@data).times do |index|
      headers << h.get_time_label_from_number(index)
    end

    headers
  end

  def h
    ApplicationController.helpers
  end
end
