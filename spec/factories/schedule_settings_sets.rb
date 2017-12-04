FactoryBot.define do
  factory :schedule_settings_set do
    holidays_enrollment_enabled [true, false].sample
    last_minute_booking_enabled [true, false].sample
    driving_school
  end
end
