FactoryBot.define do
  factory :driving_course do
    student_driving_school nil
    available_hours 20
    used_hours 0
    booked_hours 10
    category_type 0
  end
end
