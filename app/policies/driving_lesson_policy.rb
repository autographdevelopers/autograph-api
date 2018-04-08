class DrivingLessonPolicy < ApplicationPolicy
  allow :cancel?, :create?, if: ->{
    (user.student? && user.id == record.student.id) ||
      (user.employee? && (owner_of_driving_school?(record.driving_school.id) ||
        can_modify_schedules_in_driving_school?(record.driving_school.id)))
  }

  class Scope < Scope
    def resolve
      if user.student?
        scope.where(student_id: user.id)
      else
        scope
      end
    end
  end
end
