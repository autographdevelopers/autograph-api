FactoryBot.define do
  factory :organization_note do
    title 'test-title'
    body 'test-body'
    datetime Time.current
    driving_school
    association :author, factory: :user
  end
end
