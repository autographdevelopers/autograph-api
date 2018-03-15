FactoryBot.define do
  factory :driving_lesson do
    start_time 7.days.from_now
    student_driving_school
    employee_driving_school
  end
end
