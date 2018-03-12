class EmployeeDrivingSchoolPolicy < ApplicationPolicy
  allow :is_owner?, if: -> { record.employee_privilege_set.is_owner? }
  allow :can_manage_employees?, if: -> { record.employee_privilege_set.can_manage_employees? }
  allow :can_manage_students?, if: -> { record.employee_privilege_set.can_manage_students? }
end
