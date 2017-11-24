FactoryBot.define do
  factory :employee_driving_school do
    employee
    driving_school
    status [:pending, :active, :archived].sample
  end

  trait :with_employee_privileges do
    after(:create) do |employee_driving_school|
      create(:employee_privilege_set, employee_driving_school: employee_driving_school)
    end
  end
end
