class Booking < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :availability
  has_many :payments

  enum :status, { pending: 0, paid: 1, cancelled: 2, rejected: 3 }

  validates :status, :starts_at, :ends_at, presence: true
  validate :ends_at_after_starts_at
  validate :not_student_overlapping
  validate :availability_capacity_not_exceeded

  scope :by_student, ->(student) { where(student: student) }

  scope :by_mentor, ->(mentor) {
  joins(:availability).where(availabilities: { mentor_id: mentor.id })
}

  scope :by_status, ->(statuses) { where(status: statuses) }

  scope :by_date, ->(date) {
    where(starts_at: date.to_date.all_day)
  }

  scope :active, -> { where.not(status: :cancelled) }

  scope :pending, -> { where(status: :pending) }

  scope :upcoming, -> { where("bookings.starts_at > ?", Time.current) }

  scope :previous, -> { where("bookings.ends_at < ?", Time.current) }

  scope :cancelled, -> { by_status(2) }

  scope :overlapping, ->(start_time, end_time) {
    where("TIME(starts_at) < ? AND TIME(ends_at) > ?", start_time, end_time)
  }

  private
  def ends_at_after_starts_at
    if ends_at <= starts_at
      errors.add(:ends_at, "debe ser posterior a la hora de inicio.")
    end
  end

  def not_student_overlapping
    overlapping_bookings = student.bookings.where.not(id: id).overlapping(starts_at, ends_at)
    if overlapping_bookings.any?
      errors.add(:base, "Ya tienes una reserva que se superpone con este horario.")
    end
  end

  def availability_capacity_not_exceeded
    return if availability.capacity.nil?

    current_bookings_count = availability.bookings.where.not(id: id).overlapping(starts_at, ends_at).count
    if current_bookings_count >= availability.capacity
      errors.add(:base, "No hay cupos libres para esta clase en el horario seleccionado.")
    end
  end
end
