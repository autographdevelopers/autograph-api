class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.student?
        scope.joins(course_participations: :student_driving_school)
             .where(student_driving_schools: { student_id: user.id })
             .distinct
      else
        scope
      end
    end
  end

  def create?
    user.employee?
  end

  def update?
    user.employee?
  end

  def archive?
    user.employee?
  end

  def index?
    true
  end
end
