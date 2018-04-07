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

ActiveRecord::Schema.define(version: 20180407162515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.bigint "driving_school_id"
    t.string "target_type"
    t.bigint "target_id"
    t.bigint "user_id"
    t.integer "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driving_school_id"], name: "index_activities_on_driving_school_id"
    t.index ["target_type", "target_id"], name: "index_activities_on_target_type_and_target_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "driving_courses", force: :cascade do |t|
    t.bigint "student_driving_school_id"
    t.integer "available_hours", default: 0, null: false
    t.integer "category_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "booked_hours", default: 0, null: false
    t.integer "used_hours", default: 0, null: false
    t.index ["student_driving_school_id"], name: "index_driving_courses_on_student_driving_school_id"
  end

  create_table "driving_lessons", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", null: false
    t.bigint "student_id", null: false
    t.bigint "employee_id", null: false
    t.bigint "driving_school_id", null: false
    t.index ["driving_school_id"], name: "index_driving_lessons_on_driving_school_id"
    t.index ["employee_id"], name: "index_driving_lessons_on_employee_id"
    t.index ["student_id"], name: "index_driving_lessons_on_student_id"
  end

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
    t.string "time_zone", null: false
    t.string "country_code", null: false
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

  create_table "employee_notifications_settings", force: :cascade do |t|
    t.boolean "push_notifications_enabled", default: false, null: false
    t.boolean "weekly_emails_reports_enabled", default: false, null: false
    t.boolean "monthly_emails_reports_enabled", default: false, null: false
    t.bigint "employee_driving_school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_driving_school_id"], name: "index_employee_notification_settings_on_employee_driving_school"
  end

  create_table "employee_privileges", force: :cascade do |t|
    t.bigint "employee_driving_school_id", null: false
    t.boolean "can_manage_employees", default: false, null: false
    t.boolean "can_manage_students", default: false, null: false
    t.boolean "can_modify_schedules", default: false, null: false
    t.boolean "is_driving", default: false, null: false
    t.boolean "is_owner", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_driving_school_id"], name: "index_employee_privileges_on_employee_driving_school_id"
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

  create_table "schedule_settings", force: :cascade do |t|
    t.boolean "holidays_enrollment_enabled", default: false, null: false
    t.boolean "last_minute_booking_enabled", default: false, null: false
    t.bigint "driving_school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "valid_time_frames", default: {"monday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "tuesday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "wednesday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "thursday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "friday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "saturday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "sunday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47]}, null: false
    t.index ["driving_school_id"], name: "index_schedule_settings_on_driving_school_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "repetition_period_in_weeks", default: 0, null: false
    t.json "current_template", default: {"monday"=>[], "tuesday"=>[], "wednesday"=>[], "thursday"=>[], "friday"=>[], "saturday"=>[], "sunday"=>[]}, null: false
    t.json "new_template", default: {"monday"=>[], "tuesday"=>[], "wednesday"=>[], "thursday"=>[], "friday"=>[], "saturday"=>[], "sunday"=>[]}, null: false
    t.date "new_template_binding_from"
    t.bigint "employee_driving_school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_driving_school_id"], name: "index_schedules_on_employee_driving_school_id"
  end

  create_table "slots", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.bigint "employee_driving_school_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "driving_lesson_id"
    t.datetime "release_at"
    t.integer "locking_user_id"
    t.index ["driving_lesson_id"], name: "index_slots_on_driving_lesson_id"
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

  create_table "user_activities", force: :cascade do |t|
    t.bigint "activity_id"
    t.bigint "user_id"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_user_activities_on_activity_id"
    t.index ["user_id"], name: "index_user_activities_on_user_id"
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
    t.boolean "allow_password_change"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "activities", "driving_schools"
  add_foreign_key "activities", "users"
  add_foreign_key "driving_courses", "student_driving_schools"
  add_foreign_key "driving_lessons", "driving_schools"
  add_foreign_key "driving_lessons", "users", column: "employee_id"
  add_foreign_key "driving_lessons", "users", column: "student_id"
  add_foreign_key "employee_driving_schools", "users", column: "employee_id"
  add_foreign_key "schedules", "employee_driving_schools"
  add_foreign_key "slots", "driving_lessons"
  add_foreign_key "slots", "employee_driving_schools"
  add_foreign_key "slots", "users", column: "locking_user_id"
  add_foreign_key "student_driving_schools", "users", column: "student_id"
  add_foreign_key "user_activities", "activities"
  add_foreign_key "user_activities", "users"
end
