FactoryBot.define do
  factory :note do
    title 'test-title'
    body 'test-body'
    context :lesson_note_from_instructor
    notable nil
    datetime Time.current
    driving_school
    association :author, factory: :user
  end
end
