# class EmployeePrivilegesPolicy
# User is allowed to modify EmployeePrivileges when he is owner or
# he can can manage employees
# Important!
# - Employee can not change his own privileges
# - Nobody can change owners privileges
class EmployeePrivilegesPolicy < ApplicationPolicy
  allow :update?, :show?, if: -> do
    # driving_school = record.employee_driving_school.driving_school.id
    # employee_driving_school = user.employee_driving_schools
    #                             .find_by(driving_school: driving_school)
    #
    # (employee_driving_school.employee_privileges.is_owner? ||
    #   employee_driving_school.employee_privileges.can_manage_employees?) &&
    #   employee_driving_school.id != record.employee_driving_school &&
    #   !record.employee_driving_school.employee_privileges.is_owner?
    true
  end
end
