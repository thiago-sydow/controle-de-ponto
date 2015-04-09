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

  def get_icon_and_text_color_balance(balance)
    text_color = 'text-success'
    icon_class = 'text-success'

    if balance.cleared?
      icon_class << ' fa-check-circle'
    elsif balance.positive?
      icon_class << ' fa-plus-circle'
    else
      icon_class = 'fa-minus-circle text-danger'
      text_color = 'text-danger'
    end

    { icon_class: icon_class, text_color: text_color }
  end


  def flash_class(type)
    case type
    when 'success' then 'success'
    when 'error'   then 'danger'
    when 'notice'  then 'info'
    when 'alert'   then 'warning'
    end
  end

  def flash_icon(type)
    case type
    when 'success' then 'fa-check'
    when 'error'   then 'fa-ban'
    when 'notice'  then 'fa-info'
    when 'alert'   then 'fa-exclamation-triangle'
    end
  end

end
