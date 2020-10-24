class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.student?
        scope.joins(:student_driving_school).where(student_id: user.id ).distinct
      elsif user.employee?
        scope
      end
    end
  end
  # ^
  def index?
    true
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

  def unarchive?
    user.employee?
  end
end
