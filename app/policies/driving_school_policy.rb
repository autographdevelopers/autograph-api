class DrivingSchoolPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.is_a? Employee
        return user.driving_schools
                 .where.not(employee_driving_schools: { status: :archived })
                 .where(status: [:pending, :active])
      elsif user.is_a? Student
        return user.driving_schools
                 .where.not(student_driving_schools: { status: :archived })
                 .where(status: [:pending, :active])
      else
        return scope.none
      end
    end
  end
end
