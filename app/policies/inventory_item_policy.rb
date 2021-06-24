class InventoryItemPolicy < ApplicationPolicy
  def create?
    user.employee?
  end

  def show?
    user.employee?
  end

  def update?
    user == record.author
  end

  def discard?
    user == record.author
  end

  def index?
    user.employee?
  end

  def attach_file?
    user == record.author
  end

  def attach_file_web?
    user == record.author
  end

  def delete_file?
    user == record.author
  end
end