# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_05_08_194138) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "doctor_id"
    t.text "notes"
    t.decimal "price"
    t.bigint "availability_id"
    t.index ["availability_id"], name: "index_appointments_on_availability_id"
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "doctor_id"
    t.date "date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "booked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_availabilities_on_doctor_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "user_one_id", null: false
    t.bigint "user_two_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_one_id", "user_two_id"], name: "index_chats_on_user_one_id_and_user_two_id", unique: true
    t.index ["user_one_id"], name: "index_chats_on_user_one_id"
    t.index ["user_two_id"], name: "index_chats_on_user_two_id"
  end

  create_table "message_attachments", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.text "file_data", null: false
    t.string "attachment_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_attachments_on_message_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "sender_id"
    t.text "content"
    t.integer "message_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.integer "role"
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "phone"
    t.date "date_of_birth"
    t.string "gender"
    t.string "bio"
    t.string "specialization"
    t.integer "experience"
    t.string "description_for_patient"
    t.text "medical_history"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "availabilities"
  add_foreign_key "appointments", "users", column: "doctor_id"
  add_foreign_key "appointments", "users", column: "patient_id"
  add_foreign_key "availabilities", "users", column: "doctor_id"
  add_foreign_key "chats", "users", column: "user_one_id"
  add_foreign_key "chats", "users", column: "user_two_id"
  add_foreign_key "message_attachments", "messages"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users", column: "sender_id"
end
