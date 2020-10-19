FactoryBot.define do
  factory :course_type do
    sequence(:name) { |n| "name-#{n}" }
    description 'Test Description'
    status :active
    driving_school
  end
end
