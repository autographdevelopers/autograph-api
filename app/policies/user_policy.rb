class UserPolicy < ApplicationPolicy
  def employee?
    user.employee?
  end
end
