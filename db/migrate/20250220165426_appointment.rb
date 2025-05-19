class Appointment < ActiveRecord::Migration[7.2]
  def change
    create_table :appointments do |t|
      t.references :patient,  foreign_key: { to_table: :users }
      t.references :doctor,  foreign_key: { to_table: :users }
      t.text :notes
      t.datetime :scheduled_at
      t.decimal :price
    end
  end
end
