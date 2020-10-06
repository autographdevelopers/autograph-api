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
      can_modify_schedules false
    end

    after(:create) do |employee_driving_school, evaluator|
      create(:employee_privileges,
             employee_driving_school: employee_driving_school,
             is_owner: evaluator.is_owner,
             can_manage_employees: evaluator.can_manage_employees,
             can_manage_students: evaluator.can_manage_students,
             is_driving: evaluator.is_driving,
             can_modify_schedules: evaluator.can_modify_schedules
      )
      create(:employee_notifications_settings, employee_driving_school: employee_driving_school)
      employee_driving_school.create_avatar_placeholder_color!(
          hex_val: Color.find_rarest_color_in(
              model: EmployeeDrivingSchool,
              school_id: employee_driving_school.driving_school_id,
              color_application: :avatar_placeholder
          ) || Color::DEFAULT_AVATAR_PLACEHOLDER_COLOR_HEX
      )
    end
  end
end
