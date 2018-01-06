FactoryBot.define do
  factory :invitation do
    sequence(:email) { |n| "email#{n}@gmail.com" }
    first_name "Jon"
    last_name "Snow"
    invitable nil
  end
end
