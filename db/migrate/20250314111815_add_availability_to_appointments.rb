class AddAvailabilityToAppointments < ActiveRecord::Migration[7.2]
  def change
    add_reference :appointments, :availability, foreign_key: true
  end
end
