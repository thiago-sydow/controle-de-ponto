module ApplicationHelper

  def get_time_label_from_number(index)
    "#{type_label(index)} #{number_label(index)}"
  end

  def get_text_color_balance(balance)

    if balance.cleared? || balance.positive?
      text_color = 'text-success'
    else
      text_color = 'text-danger'
    end

  end

  def get_icon_balance(balance)

    if balance.cleared?
      return 'fa-check-circle'
    elsif balance.positive?
      return 'fa-plus-circle'
    end

    'fa-minus-circle'
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

  private

  def type_label(index)
    index % 2 == 0 ? 'Entrada' : 'Saída'
  end


  def number_label(index)
    ((index + 1) / 2.to_f).ceil
  end

end
