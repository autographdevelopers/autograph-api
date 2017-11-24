FactoryBot.define do
  factory :student_driving_school do
    student
    driving_school
    status [:pending, :active, :archived].sample
  end
end
