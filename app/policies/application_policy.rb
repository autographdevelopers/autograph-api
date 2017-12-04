class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def owner_of_driving_school?(driving_school_id)
    privileges = EmployeeDrivingSchool.find_by(employee_id: user.id, driving_school_id: driving_school_id).employee_privilege_set
    privileges.is_owner?
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
end
