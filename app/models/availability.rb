class Availability < ApplicationRecord
  belongs_to :doctor, class_name: "User"
  has_one :appointment, dependent: :destroy

  validates :date, presence: true
  validates :start_time, presence: true, uniqueness: { scope: :doctor_id }
  validates :end_time, presence: true
end
