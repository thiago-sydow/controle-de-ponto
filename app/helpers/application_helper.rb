module ApplicationHelper

  def get_time_label_from_number(index)
    "#{type_label(index)} #{number_label(index)}"
  end

  private

  def type_label(index)
    index % 2 == 0 ? 'Entrada ' : 'Saída '
  end

  def number_label(index)
    ((index + 1) / 2.to_f).ceil
  end

end
