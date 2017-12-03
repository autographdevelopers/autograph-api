FactoryBot.define do
  factory :employee_driving_school do
    employee
    driving_school
    status [:pending, :active, :archived].sample

    transient do
      is_owner false
    end
  end

  trait :with_employee_privileges do
    after(:create) do |employee_driving_school, evaluator|
      create(:employee_privilege_set, employee_driving_school: employee_driving_school, is_owner: evaluator.is_owner)
    end
  end
end
