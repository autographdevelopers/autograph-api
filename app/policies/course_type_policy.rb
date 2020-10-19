class CourseTypePolicy < ApplicationPolicy
  def index?
    user.employee?
  end
end
