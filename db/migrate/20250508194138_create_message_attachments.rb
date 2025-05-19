class CreateMessageAttachments < ActiveRecord::Migration[7.2]
  def change
    create_table :message_attachments do |t|
      t.references :message, null: false, foreign_key: true
      t.text :file_data, null: false
      t.string :attachment_type, null: false

      t.timestamps
    end
  end
end
