class CreateChats < ActiveRecord::Migration[7.2]
  def change
    create_table :chats do |t|
      t.references :user_one, null: false, foreign_key: { to_table: :users }
      t.references :user_two, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :chats, [ :user_one_id, :user_two_id ], unique: true
  end
end
