module ApplicationHelper

  def get_time_label_from_number(index)
    "#{type_label(index)} #{number_label(index)}"
  end

  def get_color_balance(balance)
    return 'success' if balance.cleared? || balance.positive?

    'danger'
  end

  def get_icon_balance(balance)

    if balance.cleared?
      return 'fa-check-circle'
    elsif balance.positive?
      return 'fa-plus-circle'
    end

    'fa-minus-circle'
  end

  def get_dashboard_color(balance)

    if balance.cleared? || balance.positive?
      return 'infobox-green'
    end

    'infobox-red'
  end

  def flash_class(type)
    flashes[type]['class']
  end

  def flash_icon(type)
    flashes[type]['icon']
  end

  private

  def type_label(index)
    index % 2 == 0 ? 'Entrada' : 'Saída'
  end

  def number_label(index)
    ((index + 1) / 2.to_f).ceil
  end

  def flashes
    @flashes ||= {
      'success' => class_and_icon('success', 'fa-check'),
      'error'   => class_and_icon('danger', 'fa-ban'),
      'notice'  => class_and_icon('info', 'fa-info'),
      'alert'   => class_and_icon('warning', 'fa-exclamation-triangle')
    }
  end

  def class_and_icon(css_class, icon)
    {
      'class' => css_class,
      'icon' => icon
    }
  end

end
