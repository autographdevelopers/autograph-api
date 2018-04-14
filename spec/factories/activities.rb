FactoryBot.define do
  factory :activity do
    driving_school
    target { create(:driving_lesson) }
    user
    activity_type 1
  end
end
