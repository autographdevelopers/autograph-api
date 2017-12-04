class DrivingSchoolPolicy < ApplicationPolicy
  def confirm_registration?
    is_owner?
  end

  def is_owner?
    privileges = EmployeeDrivingSchool.find_by(employee_id: user.id, driving_school_id: record.id).employee_privilege_set
    privileges.is_owner?
  end

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
