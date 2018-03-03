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
    latitude FFaker::Geolocation.lat
    longitude FFaker::Geolocation.lng
    time_zone 'Poland'
  end

  trait :with_schedule_settings_set do
    after(:create) do |driving_school|
      create(:schedule_settings_set, driving_school: driving_school)
    end
  end

  trait :with_schedule_boundaries do
    after(:create) do |driving_school|
      ScheduleBoundary.weekdays.keys.each do |weekday|
        create(:schedule_boundary, driving_school: driving_school, weekday: weekday)
      end
    end
  end
end
