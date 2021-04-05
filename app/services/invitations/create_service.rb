class Invitations::CreateService
  def initialize(driving_school, invited_user_type, invited_user_params, invited_user_privileges_params)
    @driving_school = driving_school
    @invited_user_type = invited_user_type
    @invited_user_params = invited_user_params
    @invited_user_privileges_params = invited_user_privileges_params

    validate_invited_user_type

    # bug email sent but got "employee_id":["has already been taken"]} error later on
    @invited_user = User.invite!(
      email: invited_user_params[:email],
      type: invited_user_type,
      name: invited_user_params[:name],
      surname: invited_user_params[:surname]
    )

    validate_type_to_match_invited_user
  end

  def call
    user_driving_school = nil

    invited_user.becomes!(invited_user.type.constantize)

    ActiveRecord::Base.transaction do
      if invited_user_type == User::EMPLOYEE
        employee_driving_school = EmployeeDrivingSchool.create!(
          employee_id: invited_user.id,
          driving_school: driving_school
        )
        employee_driving_school.create_employee_privileges!(invited_user_privileges_params)
        employee_driving_school.create_employee_notifications_settings!
        # employee_driving_school.create_invitation!(invited_user_params) unless invited_user
        user_driving_school = employee_driving_school
      elsif invited_user_type == User::STUDENT
        student_driving_school = StudentDrivingSchool.create!(
          student_id: invited_user.id,
          driving_school: driving_school
        )
        # student_driving_school.create_invitation!(invited_user_params) unless invited_user
        user_driving_school = student_driving_school
      end
    end

    # Information about cooperation request
    # InvitationMailer.cooperation_email(
    #   invited_user_params[:email],
    #   invited_user_type,
    #   invited_user.present?,
    #   driving_school
    # ).deliver

    user_driving_school
  end

  private

  attr_reader :driving_school, :invited_user_type, :invited_user_params,
    :invited_user_privileges_params, :invited_user

  def validate_invited_user_type
    raise ActiveRecord::SubclassNotFound unless User::TYPES.include?(invited_user_type)
  end

  def validate_type_to_match_invited_user
    if invited_user && invited_user.type != invited_user_type
      raise ArgumentError.new('Invited user already exists but with different role.')
    end
  end
end