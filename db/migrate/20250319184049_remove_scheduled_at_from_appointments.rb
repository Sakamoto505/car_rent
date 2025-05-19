class RemoveScheduledAtFromAppointments < ActiveRecord::Migration[7.2]
  def change
    remove_column :appointments, :scheduled_at, :datetime
  end
end
