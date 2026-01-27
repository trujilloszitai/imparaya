class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { student: 0, mentor: 1 }

  has_many :availabilities, foreign_key: :mentor_id, dependent: :destroy
  has_many :bookings, foreign_key: :student_id
  has_many :payments, through: :bookings

  # maybe should add some scopes
  scope :mentors, -> { where(role: :mentor) }
  scope :students, -> { where(role: :student) }
  scope :with_bookings, -> {
    joins(:bookings)
  }
  scope :with_bookings_by_mentor, ->(mentor) {
    with_bookings
    .merge(Booking.by_mentor(mentor))
    .distinct
  }
  scope :with_upcoming_bookings_by_mentor, ->(mentor) {
    students
    .joins(:bookings)
    .merge(Booking.by_mentor(mentor).upcoming)
    .distinct
  }

  def full_name
    "#{first_name} #{last_name}"
  end
end
