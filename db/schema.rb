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

ActiveRecord::Schema.define(version: 20180223080856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "driving_schools", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_numbers", default: [], null: false, array: true
    t.string "emails", default: [], null: false, array: true
    t.string "website_link"
    t.text "additional_information"
    t.string "city", null: false
    t.string "zip_code", null: false
    t.string "street", null: false
    t.string "country", null: false
    t.integer "status", default: 0, null: false
    t.string "profile_picture"
    t.string "verification_code", null: false
    t.decimal "latitude", precision: 9, scale: 6
    t.decimal "longitude", precision: 9, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_driving_schools_on_name"
  end

  create_table "employee_driving_schools", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "driving_school_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driving_school_id"], name: "index_employee_driving_schools_on_driving_school_id"
    t.index ["employee_id"], name: "index_employee_driving_schools_on_employee_id"
  end

  create_table "employee_notifications_settings_sets", force: :cascade do |t|
    t.boolean "push_notifications_enabled", default: false, null: false
    t.boolean "weekly_emails_reports_enabled", default: false, null: false
    t.boolean "monthly_emails_reports_enabled", default: false, null: false
    t.bigint "employee_driving_school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_driving_school_id"], name: "index_employee_notification_settings_on_employee_driving_school"
  end

  create_table "employee_privilege_sets", force: :cascade do |t|
    t.bigint "employee_driving_school_id", null: false
    t.boolean "can_manage_employees", default: false, null: false
    t.boolean "can_manage_students", default: false, null: false
    t.boolean "can_modify_schedules", default: false, null: false
    t.boolean "is_driving", default: false, null: false
    t.boolean "is_owner", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_driving_school_id"], name: "index_employee_privilege_sets_on_employee_driving_school_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "surname"
    t.string "invitable_type"
    t.bigint "invitable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitable_type", "invitable_id"], name: "index_invitations_on_invitable_type_and_invitable_id"
  end

  create_table "schedule_boundaries", force: :cascade do |t|
    t.integer "weekday", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.bigint "driving_school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driving_school_id"], name: "index_schedule_boundaries_on_driving_school_id"
  end

  create_table "schedule_settings_sets", force: :cascade do |t|
    t.boolean "holidays_enrollment_enabled", default: false, null: false
    t.boolean "last_minute_booking_enabled", default: false, null: false
    t.bigint "driving_school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driving_school_id"], name: "index_schedule_settings_sets_on_driving_school_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "repetition_period_in_weeks", default: 12, null: false
    t.json "slots_template", default: {}, null: false
    t.bigint "employee_driving_school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_driving_school_id"], name: "index_schedules_on_employee_driving_school_id"
  end

  create_table "slots", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.bigint "employee_driving_school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_driving_school_id"], name: "index_slots_on_employee_driving_school_id"
  end

  create_table "student_driving_schools", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "driving_school_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driving_school_id"], name: "index_student_driving_schools_on_driving_school_id"
    t.index ["student_id"], name: "index_student_driving_schools_on_student_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", null: false
    t.string "surname", null: false
    t.string "email", null: false
    t.integer "gender", null: false
    t.integer "status", default: 0
    t.date "birth_date", null: false
    t.string "type", null: false
    t.string "time_zone", null: false
    t.string "avatar"
    t.string "phone_number"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "employee_driving_schools", "users", column: "employee_id"
  add_foreign_key "schedules", "employee_driving_schools"
  add_foreign_key "slots", "employee_driving_schools"
  add_foreign_key "student_driving_schools", "users", column: "student_id"
end
