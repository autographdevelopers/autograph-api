class CoursePolicy < ApplicationPolicy
  def index?
    user.is_owner?(record.driving_school)
  end
end
