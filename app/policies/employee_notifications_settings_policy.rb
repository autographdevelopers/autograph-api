class EmployeeNotificationsSettingsPolicy < ApplicationPolicy
  allow :update?, :show?, if: lambda {
    record.employee_driving_school.employee_privileges.is_owner?
  }
end
