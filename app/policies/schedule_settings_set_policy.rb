class ScheduleSettingsSetPolicy < ApplicationPolicy
  def update?
    privileges = EmployeeDrivingSchool.find_by(employee_id: user.id, driving_school_id: record.driving_school.id).employee_privilege_set
    privileges.is_owner?
  end
end
