class Category < ApplicationRecord
  has_many :availabilities, dependent: :nullify
  validates :name, presence: true, uniqueness: true
end
