FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "name-#{n}" }
    description 'Test Description'
    status :active
    start_time nil
    end_time nil
    driving_school
    course_type
  end
end