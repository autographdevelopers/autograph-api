json.extract! schedule_settings,
              :id,
              :holidays_enrollment_enabled,
              :last_minute_booking_enabled,
              :minimum_slots_count_per_driving_lesson,
              :maximum_slots_count_per_driving_lesson,
              :can_student_book_driving_lesson,
              :booking_advance_period_in_weeks,
              :driving_school_id

json.valid_time_frames do
  json.monday { json.array! schedule_settings.valid_time_frames['monday'].map(&:to_i).sort! }
  json.tuesday { json.array! schedule_settings.valid_time_frames['tuesday'].map(&:to_i).sort! }
  json.wednesday { json.array! schedule_settings.valid_time_frames['wednesday'].map(&:to_i).sort! }
  json.thursday { json.array! schedule_settings.valid_time_frames['thursday'].map(&:to_i).sort! }
  json.friday { json.array! schedule_settings.valid_time_frames['friday'].map(&:to_i).sort! }
  json.saturday { json.array! schedule_settings.valid_time_frames['saturday'].map(&:to_i).sort! }
  json.sunday { json.array! schedule_settings.valid_time_frames['sunday'].map(&:to_i).sort! }
end
