class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :sender,  foreign_key: { to_table: :users }
      t.text :content
      t.integer :message_type

      t.timestamps
    end
  end
end
