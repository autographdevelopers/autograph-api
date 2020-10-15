FactoryBot.define do
  factory :course do
    name 'Test Course'
    description 'Test Description'
    status :active
    start_time nil
    end_time nil
    driving_school
  end
end
