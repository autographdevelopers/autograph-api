FactoryBot.define do
  factory :driving_school do
    name FFaker::Company.name
    phone_number FFaker::PhoneNumber.phone_number
    email FFaker::Internet.email
    website_link FFaker::Internet.http_url
    additional_information FFaker::Lorem.paragraph
    city FFaker::Address.city
    zip_code FFaker::AddressUS.zip_code
    street FFaker::AddressUS.street_address
    country FFaker::AddressUS.country
    status [:pending, :active, :blocked, :removed].sample
    profile_picture 'default_picture_path'
    latitude FFaker::Geolocation.lat
    longitude FFaker::Geolocation.lng
  end

  trait :with_schedule_settings do
    after(:create) do |driving_school|
      create(:schedule_settings, driving_school: driving_school)
    end
  end
end
