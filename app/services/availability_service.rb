class AvailabilityService
  def self.create_availabilities(doctor, slots)
    slots.each do |slot|
      start_time = Time.iso8601(slot[:start]).utc
      end_time = Time.iso8601(slot[:end]).utc

      existing_slot = Availability.find_by(doctor_id: doctor.id, start_time: start_time)

      unless existing_slot
        Availability.create!(
          doctor_id: doctor.id,
          date: start_time.to_date,
          start_time: start_time,
          end_time: end_time,
          booked: false
        )
      end
    end
  end
end
