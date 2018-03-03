class SchedulePolicy < ApplicationPolicy
  allow :update?, if: -> do
    driving_school_id = record.employee_driving_school.driving_school.id
    owner_of_driving_school?(driving_school_id) || can_manage_employees_in_driving_school?(driving_school_id)
  end
end
