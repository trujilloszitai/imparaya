class Payment < ApplicationRecord
  belongs_to :booking

  validates :mp_payment_id, presence: true, uniqueness: true

  scope :by_booking, ->(booking) { where(booking: booking) }
  scope :by_status, ->(statuses) { where(status: statuses) }
  scope :approved, -> { where(status: "approved") }
  scope :pending, -> { where(status: "pending") }
end
