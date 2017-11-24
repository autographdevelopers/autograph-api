FactoryBot.define do
  factory :employee_privilege_set do
    employee_driving_school
    can_manage_employees [true, false].sample
    can_manage_students [true, false].sample
    can_modify_schedules [true, false].sample
    is_driving [true, false].sample
    is_owner [true, false].sample
  end
end
