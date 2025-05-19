class AddFieldsUser < ActiveRecord::Migration[7.2]
  def change
    change_table :users, bulk: true do |t|
      t.integer :role
      t.string :last_name
      t.string :first_name
      t.string :middle_name

      t.string :phone
      t.date :date_of_birth
      t.string :gender

      # Для врача
      t.string :bio
      t.string :specialization
      t.integer :experience

      # Для пациента
      t.string :description_for_patient
      t.text   :medical_history
    end
  end
end
