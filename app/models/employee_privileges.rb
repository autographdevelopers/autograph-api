class EmployeePrivileges < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :employee_driving_school

  # == Validations ============================================================
  validates :can_manage_employees, :can_manage_students, :can_modify_schedules,
            :is_driving, :is_owner, inclusion: { in: [true, false] }
end
