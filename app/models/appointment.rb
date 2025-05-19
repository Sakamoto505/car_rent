class Appointment < ApplicationRecord
  belongs_to :patient, class_name: "User", dependent: :destroy
  belongs_to :doctor, class_name: "User", dependent: :destroy
  belongs_to :availability, dependent: :destroy
  # validates :scheduled_at, presence: true
end
