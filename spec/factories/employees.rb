FactoryBot.define do
  factory :employee do
    sequence(:email) { |n| "employee#{n}@gmail.com" }
    password 'Password1!'
    gender [:male, :female].sample
    birth_date FFaker::Time.between(70.years.ago, 18.years.ago)
    name FFaker::Name.first_name
    surname FFaker::Name.last_name
    phone_number FFaker::PhoneNumber.phone_number
    time_zone "+01:00"
    avatar FFaker::Avatar.image
    type User::EMPLOYEE
    confirmed_at DateTime.now
  end
end
