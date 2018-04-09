FactoryBot.define do
  factory :schedule_settings do
    holidays_enrollment_enabled false
    last_minute_booking_enabled false
    valid_time_frames { {
      monday: ScheduleSettings::SLOT_START_TIMES.keys,
      tuesday: ScheduleSettings::SLOT_START_TIMES.keys,
      wednesday: ScheduleSettings::SLOT_START_TIMES.keys,
      thursday: ScheduleSettings::SLOT_START_TIMES.keys,
      friday: ScheduleSettings::SLOT_START_TIMES.keys,
      saturday: ScheduleSettings::SLOT_START_TIMES.keys,
      sunday: ScheduleSettings::SLOT_START_TIMES.keys,
    } }
    driving_school
    minimum_slots_count_per_driving_lesson 1
    maximum_slots_count_per_driving_lesson 8
    can_student_book_driving_lesson true
  end
end
