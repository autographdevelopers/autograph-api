FactoryBot.define do
  factory :course_type do
    name 'Test Course'
    description 'Test Description'
    status :active
    driving_school
  end
end
