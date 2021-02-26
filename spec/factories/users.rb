FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@gmail.com" }
    password { 'Password1!' }
    gender { [:male, :female].sample }
    birth_date { FFaker::Time.between(70.years.ago, 18.years.ago) }
    name { FFaker::Name.first_name }
    surname { FFaker::Name.last_name }
    phone_number { FFaker::PhoneNumber.phone_number }
    time_zone { "+01:00" }
    type { User::TYPES.sample }
    confirmed_at { DateTime.now }
  end
end
