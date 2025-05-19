class CreateAvailabilities < ActiveRecord::Migration[7.2]
  def change
    create_table :availabilities do |t|
      t.references :doctor, foreign_key: { to_table: :users }
      t.date :date
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :booked

      t.timestamps
    end
  end
end
