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

  def get_icon_and_text_color_balance(work_statistics)
    if !work_statistics[:positive]
      icon_class = 'fa-minus-circle text-danger'
      text_color = 'text-danger'
    elsif work_statistics[:balance].hour > 0 || work_statistics[:balance].min > 0
      icon_class = 'fa-plus-circle text-success'
      text_color = 'text-success'
    else
      icon_class = 'fa-check-circle text-success'
      text_color = 'text-success'
    end

    { icon_class: icon_class, text_color: text_color }
  end


  def flash_class(type)
    case type
    when 'success' then 'success'
    when 'error' then 'danger'
    when 'notice' then 'info'
    when 'alert' then  'warning'
    end
  end

  def flash_icon(type)
    case type
    when 'success' then 'fa-check'
    when 'error' then 'fa-ban'
    when 'notice' then 'fa-info'
    when 'alert' then 'fa-exclamation-triangle'
    end
  end

end
