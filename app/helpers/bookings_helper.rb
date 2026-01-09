module BookingsHelper
  def format_booking_datetime(datetime)
    datetime.strftime("%d/%m/%Y %H:%M")
  end

  def format_booking_date(datetime)
    datetime.strftime("%d/%m/%Y")
  end

  def format_booking_time(datetime)
    datetime.strftime("%H:%M")
  end

  def booking_status_badge(booking)
    content_tag(:span,
      booking.status.upcase,
      class: "badge status-#{booking.status} w-fit-content text-uppercase"
    )
  end

  def booking_price_badge(booking)
    content_tag(:span,
      "$#{number_with_precision(booking.price, precision: 2)}",
      class: "badge bg-success"
    )
  end

  def booking_participant_name(booking, current_user)
    if current_user.mentor?
      booking.student.full_name
    else
      booking.availability.mentor.full_name
    end
  end

  def booking_time_range(booking)
    "#{format_booking_time(booking.starts_at)} - #{format_booking_time(booking.ends_at)}"
  end

  def booking_status_select(booking, form)
    form.input :status,
              collection: Booking.statuses.keys,
              selected: booking.status,
              label: false,
              input_html: {
                onchange: "this.form.requestSubmit()",
                class: "form-select form-select-sm"
              }
  end

  def render_bookings_or_empty(bookings, empty_message: "No tienes reservas aún.", &block)
    if bookings.any?
      capture(&block)
    else
      content_tag(:div, empty_message, class: "alert alert-info")
    end
  end

  def show_booking_path(booking)
    if current_user.mentor?
      mentors_booking_path(booking.id)
    else
      students_booking_path(booking.id)
    end
  end

  def new_booking_link_for_student
    link_to "Nueva Reserva", mentors_path, class: "btn btn-primary"
  end
end
