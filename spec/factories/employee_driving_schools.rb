FactoryBot.define do
  factory :employee_driving_school do
    employee
    driving_school
    status [:pending, :active, :archived].sample

    transient do
      is_owner false
      can_manage_employees false
      can_manage_students false
      is_driving false
    end

    after(:create) do |employee_driving_school, evaluator|
      create(:employee_privilege_set,
             employee_driving_school: employee_driving_school,
             is_owner: evaluator.is_owner,
             can_manage_employees: evaluator.can_manage_employees,
             can_manage_students: evaluator.can_manage_students,
             is_driving: evaluator.is_driving
      )
      create(:employee_notifications_settings, employee_driving_school: employee_driving_school)
    end
  end
end
