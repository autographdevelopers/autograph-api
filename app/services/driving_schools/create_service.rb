class DrivingSchools::CreateService
  def initialize(user, driving_school_params)
    @user = user
    @params = driving_school_params
  end

  def call
    DrivingSchool.transaction do
      driving_school = DrivingSchool.create!(params)
      employee_driving_school = EmployeeDrivingSchool.create!(
        employee: user, driving_school: driving_school, status: :active
      )
      employee_driving_school.create_avatar_placeholder_color!(
        hex_val: Color.find_rarest_color_in(
          model: EmployeeDrivingSchool,
          school_id: driving_school.id,
          color_application: :avatar_placeholder
        )
      )
      EmployeePrivileges.create!(
        employee_driving_school: employee_driving_school,
        can_manage_employees: true,
        can_manage_students: true,
        can_modify_schedules: true,
        is_driving: false,
        is_owner: true
      )
      EmployeeNotificationsSettings.create!(
        employee_driving_school: employee_driving_school
      )
      ScheduleSettings.create!(
        driving_school: driving_school,
        holidays_enrollment_enabled: false,
        last_minute_booking_enabled: false
      )

      employee_driving_school
    end
  end

  private

  attr_reader :user, :params
end
