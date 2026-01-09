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

ActiveRecord::Schema[8.1].define(version: 2026_01_04_064722) do
  create_table "availabilities", force: :cascade do |t|
    t.integer "capacity"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.integer "day_of_week", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.time "ends_at", null: false
    t.integer "mentor_id", null: false
    t.decimal "price_per_hour", precision: 10, scale: 2, null: false
    t.time "starts_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_availabilities_on_category_id"
    t.index ["deleted_at"], name: "index_availabilities_on_deleted_at"
    t.index ["mentor_id"], name: "index_availabilities_on_mentor_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "availability_id", null: false
    t.datetime "created_at", null: false
    t.datetime "ends_at", null: false
    t.string "preference_id"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "starts_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_id"], name: "index_bookings_on_availability_id"
    t.index ["preference_id"], name: "index_bookings_on_preference_id"
    t.index ["student_id"], name: "index_bookings_on_student_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.string "name", default: "", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "booking_id", null: false
    t.datetime "created_at", null: false
    t.string "external_reference"
    t.string "mp_payment_id"
    t.decimal "net_received_amount", precision: 10, scale: 2
    t.string "payer_email"
    t.string "payment_method_id"
    t.string "status"
    t.string "status_detail"
    t.decimal "transaction_amount", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
    t.index ["mp_payment_id"], name: "index_payments_on_mp_payment_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "biography"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "availabilities", "categories"
  add_foreign_key "availabilities", "users", column: "mentor_id"
  add_foreign_key "bookings", "availabilities"
  add_foreign_key "bookings", "users", column: "student_id"
  add_foreign_key "payments", "bookings"
end
