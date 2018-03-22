FactoryBot.define do
  factory :driving_lesson do
    start_time 7.days.from_now
    student
    employee
    driving_school
  end
end
