# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_28_114539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "start_appointment"
    t.datetime "end_appointment"
    t.string "status"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id"
    t.integer "customer_id"
    t.index ["service_id"], name: "index_appointments_on_service_id"
  end

  create_table "opening_hours", force: :cascade do |t|
    t.string "day"
    t.time "start_hour"
    t.time "end_hour"
    t.bigint "salon_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["salon_id"], name: "index_opening_hours_on_salon_id"
  end

  create_table "partenaires", force: :cascade do |t|
    t.string "prenom", null: false
    t.string "nom", null: false
    t.string "telephone", null: false
    t.string "email", null: false
    t.string "nomInstitut", null: false
    t.string "adresseInstitut", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "photo_url"
    t.bigint "salon_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["salon_id"], name: "index_photos_on_salon_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "role"
    t.bigint "user_id"
    t.bigint "salon_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["salon_id"], name: "index_roles_on_salon_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "salons", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "address"
    t.string "city"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "duration"
    t.bigint "salon_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.integer "price_cents", default: 0, null: false
    t.string "money"
    t.index ["salon_id"], name: "index_services_on_salon_id"
  end

  create_table "skills", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number", default: "", null: false
    t.string "city"
    t.string "address"
    t.date "birthday"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "working_hours", force: :cascade do |t|
    t.datetime "start_shift"
    t.datetime "end_shift"
    t.bigint "user_id"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_working_hours_on_service_id"
    t.index ["user_id"], name: "index_working_hours_on_user_id"
  end

  add_foreign_key "appointments", "services"
  add_foreign_key "appointments", "users", column: "customer_id"
  add_foreign_key "appointments", "users", column: "employee_id"
  add_foreign_key "opening_hours", "salons"
  add_foreign_key "photos", "salons"
  add_foreign_key "roles", "salons"
  add_foreign_key "roles", "users"
  add_foreign_key "services", "salons"
  add_foreign_key "working_hours", "services"
  add_foreign_key "working_hours", "users"
end
