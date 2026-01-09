module AvailabilitiesHelper
  def format_availability_time_range(availability)
    "#{availability.starts_at.strftime('%H:%M')} - #{availability.ends_at.strftime('%H:%M')}"
  end

  def availability_price_badge(availability)
    content_tag(:span,
      "$#{number_with_precision(availability.price_per_hour, precision: 2)}/hora",
      class: "badge bg-success"
    )
  end

  def day_name(day_of_week)
    Date::DAYNAMES[day_of_week]
  end

  def availability_capacity_text(availability)
    return nil unless availability.capacity
    "Capacidad: #{availability.capacity}"
  end

  def render_availabilities_or_empty(availabilities, empty_message: "No hay horarios disponibles.", &block)
    if availabilities.any?
      capture(&block)
    else
      content_tag(:div, empty_message, class: "alert alert-info mb-0")
    end
  end
end
