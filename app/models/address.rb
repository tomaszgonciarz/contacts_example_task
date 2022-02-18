class Address < ApplicationRecord
  belongs_to :contact

  validates :city, presence: true
  validates_numericality_of :house_number, only_integer: true, greater_than: 0
end
