class CustomActivityTypePolicy < ApplicationPolicy
  def index?
    user.employee?
  end

  def create?
    user.employee?
  end

  def update?
    user.employee?
  end

  def discard?
    user.employee?
  end

  def assert_test_activity?
    user.employee?
  end
end
