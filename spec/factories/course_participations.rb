FactoryBot.define do
  factory :course_participation_detail do
    student_driving_school
    driving_school
    course
    available_slot_credits { 40 }
  end
end
