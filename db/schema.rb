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

ActiveRecord::Schema.define(version: 2019_07_02_132256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "computers", force: :cascade do |t|
    t.string "title", null: false
    t.text "specifications"
    t.integer "cost", null: false
    t.datetime "creation", null: false
    t.datetime "last_service"
    t.integer "service_frequency", default: 9
    t.boolean "service_needed", default: false
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "computer_id"
    t.bigint "user_id"
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.boolean "payed", default: false
    t.index ["computer_id"], name: "index_reservations_on_computer_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "software_requests", force: :cascade do |t|
    t.bigint "computer_id"
    t.bigint "user_id"
    t.string "title", null: false
    t.string "url", null: false
    t.text "description"
    t.boolean "completed"
    t.index ["computer_id"], name: "index_software_requests_on_computer_id"
    t.index ["user_id"], name: "index_software_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "credits", default: 0
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "reservations", "computers"
  add_foreign_key "reservations", "users"
  add_foreign_key "software_requests", "computers"
  add_foreign_key "software_requests", "users"
end
