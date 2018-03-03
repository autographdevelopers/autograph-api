FactoryBot.define do
  factory :schedule do
    repetition_period_in_weeks 4
    new_template_binding_from 1.week.from_now.to_date
    current_template { {
      monday: (16..31).to_a,
      tuesday: (16..31).to_a,
      wednesday: (16..31).to_a,
      thursday: (16..31).to_a,
      friday: (16..31).to_a,
      saturday: [],
      sunday: [],
    } }
    new_template { {
      monday: [],
      tuesday: [],
      wednesday: (16..31).to_a,
      thursday: (16..31).to_a,
      friday: (16..31).to_a,
      saturday: (16..31).to_a,
      sunday: (16..31).to_a,
    } }
    employee_driving_school
  end
end
