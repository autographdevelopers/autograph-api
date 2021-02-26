FactoryBot.define do
  factory :notifiable_user_activity do
    activity { nil }
    user { nil }
    read { false }
  end
end
