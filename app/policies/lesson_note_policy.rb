class LessonNotePolicy < ApplicationPolicy
  def create?
    user.employee?
  end

  def update?
    user == record.author
  end

  def index?
    user.employee? || record.student == user
  end
end
