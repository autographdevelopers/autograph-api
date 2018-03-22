class DrivingLessonPolicy < ApplicationPolicy
  allow :cancel, if: ->{
    (user.student? && user.id == record.student.id) ||
      (user.employee? && owner_of_driving_school?(record.driving_school.id) ||
        can_modify_schedules_in_driving_school?(record.driving_school.id))
  }
end
