FactoryBot.define do
  factory :activity do
    driving_school
    target { create(:driving_lesson) }
    user
    activity_type { :student_invitation_sent }
  end
end
