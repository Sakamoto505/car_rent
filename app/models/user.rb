class User < ApplicationRecord
  has_one_attached :avatar
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :patient_appointments, class_name: "Appointment", foreign_key: :patient_id, dependent: :destroy
  has_many :doctor_appointments, class_name: "Appointment", foreign_key: :doctor_id, dependent: :destroy
  has_many :availabilities, foreign_key: "doctor_id", dependent: :destroy



  enum role: { patient: 0, doctor: 1 }
  enum specialization: {
    therapist: "therapist",
    cardiologist: "cardiologist",
    neurologist: "neurologist",
    dermatologist: "dermatologist",
    surgeon: "surgeon",
    dentist: "dentist",
    ophthalmologist: "ophthalmologist",
    gynecologist: "gynecologist",
    pediatrician: "pediatrician",
    psychiatrist: "psychiatrist"
  }, _prefix: true

  #   Валидации накинем после тестов, валидации должны будут учитывать роль
end
