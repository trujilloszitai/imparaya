class Availability < ApplicationRecord
  acts_as_paranoid
  belongs_to :mentor, class_name: "User"
  belongs_to :category, optional: true
  has_many :bookings

  validates :day_of_week, presence: true, inclusion: { in: 0..6 }
  validates :starts_at, :ends_at, :price_per_hour, presence: true
  validate :ends_at_after_starts_at

  scope :by_category, ->(category) { where(category: category) }
  scope :by_mentor, ->(mentor) { where(mentor: mentor) }
  scope :with_bookings, -> { includes(:bookings) }
  scope :individual, -> { where(capacity: 1) }
  scope :no_limit, -> { where(capacity: nil) }
  scope :by_price_range, ->(min, max) { where(price_per_hour: min..max) }

  def is_available?(date)
    return true if capacity.nil?
    bookings.by_date(date).count < capacity
  end

  def duration
    ((ends_at - starts_at) / 1.hour).round(2)
  end

  private

  def ends_at_after_starts_at
    if starts_at.present? && ends_at.present? && ends_at <= starts_at
      errors.add(:ends_at, "debe ser posterior a la hora de inicio")
    end
  end
end
