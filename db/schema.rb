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

ActiveRecord::Schema.define(version: 20201114195734) do

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
    t.string "message"
    t.index ["driving_school_id"], name: "index_activities_on_driving_school_id"
    t.index ["target_type", "target_id"], name: "index_activities_on_target_type_and_target_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "colorable_colors", force: :cascade do |t|
    t.string "colorable_type"
    t.bigint "colorable_id"
    t.string "hex_val", null: false
    t.integer "application", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["colorable_type", "colorable_id"], name: "index_colorable_colors_on_colorable_type_and_colorable_id"
    t.index ["hex_val", "colorable_type", "colorable_id", "application"], name: "index_col_col_hex_appl_uniq", unique: true
  end

  create_table "colors", force: :cascade do |t|
    t.string "palette_name", null: false
    t.string "hex_val", null: false
    t.integer "application", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_participation_details", force: :cascade do |t|
    t.bigint "student_driving_school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id", null: false
    t.integer "status", default: 0, null: false
    t.bigint "driving_school_id", null: false
    t.datetime "discarded_at"
    t.integer "booked_slots_count", default: 0, null: false
    t.integer "used_slots_count", default: 0, null: false
    t.integer "available_slot_credits", default: 0, null: false
    t.index ["course_id"], name: "index_course_participation_details_on_course_id"
    t.index ["discarded_at"], name: "index_course_participation_details_on_discarded_at"
    t.index ["driving_school_id"], name: "index_course_participation_details_on_driving_school_id"
    t.index ["student_driving_school_id", "course_id", "status", "discarded_at"], name: "index_course_part_dets_on_stud_school_id_and_course_id_status", unique: true
    t.index ["student_driving_school_id"], name: "index_course_participation_details_on_student_driving_school_id"
  end

  create_table "course_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "status", default: 0, null: false
    t.bigint "driving_school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_course_types_on_discarded_at"
    t.index ["driving_school_id"], name: "index_course_types_on_driving_school_id"
    t.index ["name", "driving_school_id", "status"], name: "course_typ_name_school_id_status_discarded_at_uniq", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "driving_school_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "course_participations_limit"
    t.integer "course_participation_details_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.bigint "course_type_id", null: false
    t.boolean "created_automatically", default: false, null: false
    t.datetime "discarded_at"
    t.index ["course_type_id"], name: "index_courses_on_course_type_id"
    t.index ["discarded_at"], name: "index_courses_on_discarded_at"
    t.index ["driving_school_id"], name: "index_courses_on_driving_school_id"
    t.index ["name", "driving_school_id", "status", "discarded_at"], name: "courses_name_school_id_status_discarded_at_uniq", unique: true
  end

  create_table "driving_lessons", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", null: false
    t.bigint "student_id", null: false
    t.bigint "employee_id", null: false
    t.bigint "driving_school_id", null: false
    t.bigint "course_participation_detail_id", null: false
    t.index ["course_participation_detail_id"], name: "index_driving_lessons_on_course_participation_detail_id"
    t.index ["driving_school_id"], name: "index_driving_lessons_on_driving_school_id"
    t.index ["employee_id"], name: "index_driving_lessons_on_employee_id"
    t.index ["student_id"], name: "index_driving_lessons_on_student_id"
  end

  create_table "driving_schools", force: :cascade do |t|
    t.string "name", null: false
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
    t.string "email"
    t.string "phone_number"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_driving_schools_on_discarded_at"
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

  create_table "labelable_labels", force: :cascade do |t|
    t.string "labelable_type"
    t.bigint "labelable_id"
    t.bigint "label_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label_id"], name: "index_labelable_labels_on_label_id"
    t.index ["labelable_type", "labelable_id"], name: "index_labelable_labels_on_labelable_type_and_labelable_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "purpose", null: false
    t.boolean "prebuilt", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.datetime "datetime"
    t.string "notable_type", null: false
    t.bigint "notable_id", null: false
    t.bigint "driving_school_id", null: false
    t.bigint "user_id", null: false
    t.integer "context", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driving_school_id"], name: "index_notes_on_driving_school_id"
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable_type_and_notable_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notifiable_user_activities", force: :cascade do |t|
    t.bigint "activity_id"
    t.bigint "user_id"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_notifiable_user_activities_on_activity_id"
    t.index ["user_id"], name: "index_notifiable_user_activities_on_user_id"
  end

  create_table "related_user_activities", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "activity_id"
    t.index ["activity_id"], name: "index_related_user_activities_on_activity_id"
    t.index ["user_id"], name: "index_related_user_activities_on_user_id"
  end

  create_table "schedule_settings", force: :cascade do |t|
    t.boolean "holidays_enrollment_enabled", default: false, null: false
    t.boolean "last_minute_booking_enabled", default: false, null: false
    t.bigint "driving_school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "valid_time_frames", default: {"monday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "tuesday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "wednesday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "thursday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "friday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "saturday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "sunday"=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47]}, null: false
    t.integer "minimum_slots_count_per_driving_lesson", default: 1
    t.integer "maximum_slots_count_per_driving_lesson", default: 8
    t.boolean "can_student_book_driving_lesson", default: true
    t.integer "booking_advance_period_in_weeks", default: 10, null: false
    t.index ["driving_school_id"], name: "index_schedule_settings_on_driving_school_id"
  end

  create_table "schedules", force: :cascade do |t|
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
    t.string "player_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "activities", "driving_schools"
  add_foreign_key "activities", "users"
  add_foreign_key "course_participation_details", "courses"
  add_foreign_key "course_participation_details", "driving_schools"
  add_foreign_key "course_participation_details", "student_driving_schools"
  add_foreign_key "courses", "course_types"
  add_foreign_key "driving_lessons", "course_participation_details"
  add_foreign_key "driving_lessons", "driving_schools"
  add_foreign_key "driving_lessons", "users", column: "employee_id"
  add_foreign_key "driving_lessons", "users", column: "student_id"
  add_foreign_key "employee_driving_schools", "users", column: "employee_id"
  add_foreign_key "labelable_labels", "labels"
  add_foreign_key "notifiable_user_activities", "activities"
  add_foreign_key "notifiable_user_activities", "users"
  add_foreign_key "related_user_activities", "activities"
  add_foreign_key "related_user_activities", "users"
  add_foreign_key "schedules", "employee_driving_schools"
  add_foreign_key "slots", "driving_lessons"
  add_foreign_key "slots", "employee_driving_schools"
  add_foreign_key "slots", "users", column: "locking_user_id"
  add_foreign_key "student_driving_schools", "users", column: "student_id"
end
