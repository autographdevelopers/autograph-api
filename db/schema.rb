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

ActiveRecord::Schema.define(version: 2021_03_01_210036) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.bigint "driving_school_id"
    t.string "target_type"
    t.bigint "target_id"
    t.bigint "user_id"
    t.integer "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message"
    t.bigint "custom_activity_type_id"
    t.text "note"
    t.datetime "date"
    t.index ["custom_activity_type_id"], name: "index_activities_on_custom_activity_type_id"
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

  create_table "comments", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "author_id", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.bigint "driving_school_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["discarded_at"], name: "index_comments_on_discarded_at"
    t.index ["driving_school_id"], name: "index_comments_on_driving_school_id"
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

  create_table "custom_activity_types", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.string "btn_bg_color"
    t.string "message_template", null: false
    t.string "target_type"
    t.integer "notification_receivers", default: 0, null: false
    t.bigint "driving_school_id", null: false
    t.integer "datetime_input_config", default: 0
    t.string "datetime_input_instructions"
    t.integer "text_note_input_config", default: 0
    t.string "text_note_input_instructions"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_custom_activity_types_on_discarded_at"
    t.index ["driving_school_id"], name: "index_custom_activity_types_on_driving_school_id"
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

  create_table "inventory_items", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.jsonb "properties_groups", default: []
    t.bigint "driving_school_id", null: false
    t.bigint "author_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_inventory_items_on_author_id"
    t.index ["discarded_at"], name: "index_inventory_items_on_discarded_at"
    t.index ["driving_school_id"], name: "index_inventory_items_on_driving_school_id"
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

  create_table "lesson_notes", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.datetime "datetime"
    t.bigint "driving_lesson_id", null: false
    t.bigint "driving_school_id", null: false
    t.bigint "user_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["discarded_at"], name: "index_lesson_notes_on_discarded_at"
    t.index ["driving_lesson_id"], name: "index_lesson_notes_on_driving_lesson_id"
    t.index ["driving_school_id"], name: "index_lesson_notes_on_driving_school_id"
    t.index ["user_id"], name: "index_lesson_notes_on_user_id"
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

  create_table "organization_notes", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.datetime "datetime"
    t.bigint "driving_school_id", null: false
    t.bigint "user_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["discarded_at"], name: "index_organization_notes_on_discarded_at"
    t.index ["driving_school_id"], name: "index_organization_notes_on_driving_school_id"
    t.index ["user_id"], name: "index_organization_notes_on_user_id"
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

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_notes", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.datetime "datetime"
    t.bigint "author_id", null: false
    t.bigint "user_id", null: false
    t.bigint "driving_school_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["author_id"], name: "index_user_notes_on_author_id"
    t.index ["discarded_at"], name: "index_user_notes_on_discarded_at"
    t.index ["driving_school_id"], name: "index_user_notes_on_driving_school_id"
    t.index ["user_id"], name: "index_user_notes_on_user_id"
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
    t.string "name"
    t.string "surname"
    t.string "email", null: false
    t.integer "status", default: 0
    t.date "birth_date"
    t.string "type", null: false
    t.string "time_zone"
    t.string "avatar"
    t.string "phone_number"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allow_password_change"
    t.string "player_id"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "custom_activity_types"
  add_foreign_key "activities", "driving_schools"
  add_foreign_key "activities", "users"
  add_foreign_key "comments", "driving_schools"
  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "course_participation_details", "courses"
  add_foreign_key "course_participation_details", "driving_schools"
  add_foreign_key "course_participation_details", "student_driving_schools"
  add_foreign_key "courses", "course_types"
  add_foreign_key "driving_lessons", "course_participation_details"
  add_foreign_key "driving_lessons", "driving_schools"
  add_foreign_key "driving_lessons", "users", column: "employee_id"
  add_foreign_key "driving_lessons", "users", column: "student_id"
  add_foreign_key "employee_driving_schools", "users", column: "employee_id"
  add_foreign_key "inventory_items", "driving_schools"
  add_foreign_key "inventory_items", "users", column: "author_id"
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
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_notes", "users", column: "author_id"
end
