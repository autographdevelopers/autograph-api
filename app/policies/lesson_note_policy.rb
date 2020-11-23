class LessonNotePolicy < ApplicationPolicy
  def create?
    user.employee?
  end

  def update?
    user == record.author
  end
end
