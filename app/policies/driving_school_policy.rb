class DrivingSchoolPolicy < ApplicationPolicy
  allow :confirm_registration?, :owner?, if: -> { owner_of_driving_school?(record.id) }
  allow :can_manage_employees?, if: -> { owner_of_driving_school?(record.id) || can_manage_employees_in_driving_school?(record.id) }
  allow :can_manage_students?, if: -> { owner_of_driving_school?(record.id) || can_manage_students_in_driving_school?(record.id)  }

  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.employee?
        return user.driving_schools
                 .where.not(employee_driving_schools: { status: :archived })
                 .where.not(status: :removed)
      elsif user.student?
        return user.driving_schools
                 .where.not(student_driving_schools: { status: :archived })
                 .where.not(status: :removed)
      end
    end
  end
end
