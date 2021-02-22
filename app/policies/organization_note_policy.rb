class OrganizationNotePolicy < ApplicationPolicy
  def create?
    user.employee?
  end

  def publish?
    user.employee? && user == record.author
  end

  def update?
    user == record.author
  end

  def discard?
    user == record.author
  end

  def index?
    user.employee? || record.student == user
  end

  def attach_file?
    user == record.author
  end

  def delete_file?
    user == record.author
  end
end
