FactoryBot.define do
  factory :employee_privileges do
    employee_driving_school
    can_manage_employees false
    can_manage_students false
    can_modify_schedules false
    is_driving false
    is_owner false
  end
end
