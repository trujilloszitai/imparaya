class AvailabilityScheduler
  def initialize(availability, student, weeks_to_generate: 5)
    @availability = availability
    @mentor = availability.mentor
    @student = student
    @limit = weeks_to_generate
  end

  def perform
    slots = generate_future_slots

    bookings = fetch_blocking_bookings(slots.first[:start], slots.last[:end])

    slots.map do |slot|
      check_slot_status(slot, bookings)
    end
  end

  private

  def generate_future_slots
    slots = []
    next_date = find_next_occurrence(@availability.day_of_week)

    @limit.times do
      start_dt = TimeUtils.combine(next_date, @availability.starts_at)
      end_dt = TimeUtils.combine(next_date, @availability.ends_at)

      slots << { start: start_dt, end: end_dt }

      next_date += 1.week
    end
    slots
  end

  def fetch_blocking_bookings(start_range, end_range)
    Booking.where(starts_at: start_range..end_range)
              .joins(:availability)
               .where("availabilities.mentor_id = ? OR student_id = ?", @mentor.id, @student.id)
               .active
  end

  def check_slot_status(slot, bookings)
    mentor_bookings = bookings.count do |b|
      b.availability.mentor_id == @mentor.id && overlap?(slot, b)
    end

    student_bookings = bookings.count do |b|
      b.student_id == @student.id && overlap?(slot, b)
    end

    if student_bookings > 0
      build_response(slot, false, "Ya tienes una clase agendada")
    elsif @availability.capacity.present? && mentor_bookings >= @availability.capacity
      build_response(slot, false, "Cupo completo")
    else
      build_response(slot, true, "Disponible")
    end
  end

  # Helpers -----------------------------------------------------------

  def find_next_occurrence(day_code)
    Date.current.next_occurring(day_name(day_code))
  end

  def day_name(code)
    Date::DAYNAMES[code].downcase.to_sym
  end

  def overlap?(slot, booking)
    # (StartA < EndB) && (EndA > StartB)
    slot[:start] < booking.ends_at && slot[:end] > booking.starts_at
  end

  def build_response(slot, available, reason)
    {
      date: slot[:start],
      start_time: slot[:start],
      end_time: slot[:end],
      is_available: available,
      reason: reason
    }
  end
end
