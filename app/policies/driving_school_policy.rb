class DrivingSchoolPolicy < ApplicationPolicy
  allow :owner?, if: -> { owner_of_driving_school?(record.id) }
  allow :can_manage_employees?, if: -> { owner_of_driving_school?(record.id) || can_manage_employees_in_driving_school?(record.id) }
  allow :can_manage_students?, if: -> { owner_of_driving_school?(record.id) || can_manage_students_in_driving_school?(record.id)  }
end
