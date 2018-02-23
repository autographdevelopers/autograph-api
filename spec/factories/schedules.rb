FactoryBot.define do
  factory :schedule do
    repetition_period_in_weeks 1
    slots_template ""
    employee_driving_school nil
  end
end
