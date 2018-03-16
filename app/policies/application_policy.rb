class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def owner_of_driving_school?(driving_school_id)
    get_employee_privileges(driving_school_id).is_owner?
  end

  def can_manage_employees_in_driving_school?(driving_school_id)
    get_employee_privileges(driving_school_id).can_manage_employees?
  end

  def can_manage_students_in_driving_school?(driving_school_id)
    get_employee_privileges(driving_school_id).can_manage_students?
  end

  def is_driving?(employee_driving_school)
    employee_driving_school.employee_privileges.is_driving?
  end

  def employee?
    user.employee?
  end

  def student?
    user.student?
  end

  def self.allow(*actions, options)
    actions.each do |action|
      define_method(action) do
        instance_exec(&options[:if])
      end
    end
  end

  private

  def get_employee_privileges(driving_school_id)
    EmployeeDrivingSchool.find_by(employee_id: user.id, driving_school_id: driving_school_id).employee_privileges
  end
end
