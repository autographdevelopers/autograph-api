class Invitations::CreateService
  def initialize(driving_school, invited_user_type, invited_user_params, invited_user_privileges_params)
    @driving_school = driving_school
    @invited_user_type = invited_user_type
    @invited_user_params = invited_user_params
    @invited_user_privileges_params = invited_user_privileges_params

    @invited_user = User.find_by_email(invited_user_params[:email])

    validate_invited_user_type
    validate_type_to_match_invited_user
    validate_if_already_invited
  end

  def call
    user_driving_school = nil

    ActiveRecord::Base.transaction do
      if invited_user_type == User::EMPLOYEE
        employee_driving_school = EmployeeDrivingSchool.create!(employee: invited_user, driving_school: driving_school)
        employee_driving_school.create_employee_privileges!(invited_user_privileges_params)
        employee_driving_school.create_employee_notifications_settings!
        employee_driving_school.create_invitation!(invited_user_params) unless invited_user
        user_driving_school = employee_driving_school
      elsif invited_user_type == User::STUDENT
        student_driving_school = StudentDrivingSchool.create!(student: invited_user, driving_school: driving_school)
        student_driving_school.create_invitation!(invited_user_params) unless invited_user
        user_driving_school = student_driving_school
      end
    end

    # Information about cooperation request
    InvitationMailer.cooperation_email(
      invited_user_params[:email],
      invited_user_type,
      invited_user.present?,
      driving_school
    ).deliver

    return user_driving_school
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

  def validate_if_already_invited
    return unless invited_user

    user_driving_schools = invited_user.user_driving_schools.find_by(driving_school: driving_school)

    if user_driving_schools&.pending?
      raise ArgumentError.new('User is already invited.')
    end

    if user_driving_schools&.active?
      raise ArgumentError.new('User is already related with this school.')
    end
  end
end