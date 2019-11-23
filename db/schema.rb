ActiveRecord::Schema.define(version: 20_190_829_141_704) do
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

  create_table "reports", force: :cascade do |t|
    t.string "title", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "proceeds"
    t.integer "rent_length"
    t.integer "idle_length"
    t.bigint "user_id"
    t.string "kind", null: false
    t.index ["user_id"], name: "index_reports_on_user_id"
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
    t.boolean "owner", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "reports", "users"
  add_foreign_key "reservations", "computers"
  add_foreign_key "reservations", "users"
  add_foreign_key "software_requests", "computers"
  add_foreign_key "software_requests", "users"
end
