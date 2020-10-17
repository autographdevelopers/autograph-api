FactoryBot.define do
  factory :course_participation do
    student_driving_school nil
    course
    available_hours 20.0
  end
end
