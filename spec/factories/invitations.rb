FactoryBot.define do
  factory :invitation do
    sequence(:email) { |n| "email#{n}@gmail.com" }
    name "Jon"
    surname "Snow"
    invitable nil
  end
end
