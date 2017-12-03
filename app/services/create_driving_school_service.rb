class CreateDrivingSchoolService
  def initialize(user, driving_school_params)
    @user = user
    @params = driving_school_params
  end

  def call
    DrivingSchool.transaction do
      driving_school = DrivingSchool.create!(params)
      employee_driving_schools = EmployeeDrivingSchool.create!(employee: user, driving_school: driving_school)
      EmployeePrivilegeSet.create!(
        employee_driving_school: employee_driving_schools,
        can_manage_employees: true,
        can_manage_students: true,
        can_modify_schedules: true,
        is_driving: false,
        is_owner: true
      )

      driving_school
    end
  end

  private

  attr_reader :user, :params
end
