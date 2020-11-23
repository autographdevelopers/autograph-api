FactoryBot.define do
  factory :lesson_note do
    title 'test-title'
    body 'test-body'
    datetime Time.current
    driving_school
    driving_lesson
    association :author, factory: :user
  end
end
