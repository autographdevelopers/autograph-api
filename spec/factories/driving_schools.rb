FactoryBot.define do
  factory :driving_school do
    name FFaker::Company.name
    phone_numbers [FFaker::PhoneNumber.phone_number]
    emails [FFaker::Internet.email]
    website_link FFaker::Internet.http_url
    additional_information FFaker::Lorem.paragraph
    city FFaker::Address.city
    zip_code FFaker::AddressUS.zip_code
    street FFaker::AddressUS.street_address
    country FFaker::AddressUS.country
    status [:pending, :active, :blocked, :removed].sample
    profile_picture 'default_picture_path'
    verification_code SecureRandom.uuid
    latitude FFaker::Geolocation.lat
    longitude FFaker::Geolocation.lng
  end
end
