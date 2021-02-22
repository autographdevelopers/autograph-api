class UserNotePolicy < ApplicationPolicy
  def create?
    # user.employee?
    true
  end

  def update?
    user == record.author
  end

  def discard?
    user == record.author
  end

  def publish?
    user == record.author
  end

  def index?
    user.employee? || record == user
  end

  def attach_file?
    user == record.author
  end

  def delete_file?
    user == record.author
  end
end
