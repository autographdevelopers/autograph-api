FactoryBot.define do
  factory :slot do
    start_time "2018-02-23 09:08:56"
    employee_driving_school nil
    driving_lesson nil
  end

  trait :booked do
    after(:create) do |slot|
      slot.update(driving_lesson: create(:driving_lesson))
    end
  end
end
