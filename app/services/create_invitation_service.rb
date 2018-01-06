class CreateInvitationService
  def initialize(driving_school, invited_user_type, invited_user_params, invited_user_privileges_params)
    @driving_school = driving_school
    @invited_user_type = invited_user_type
    @invited_user_params = invited_user_params
    @invited_user_privileges_params = invited_user_privileges_params

    @invited_user = User.find_by_email(invited_user_params[:email])

    validate_invited_user_type
    validate_type_to_match_invited_user
    validate_if_already_invited if invited_user
  end

  def call
    ActiveRecord::Base.transaction do
      if invited_user_type == 'Employee'
        employee_driving_school = EmployeeDrivingSchool.create!(employee: invited_user, driving_school: driving_school)
        employee_driving_school.create_employee_privilege_set!(invited_user_privileges_params)
        employee_driving_school.create_employee_notifications_settings_set!
        employee_driving_school.create_invitation!(invited_user_params) unless invited_user
      elsif invited_user_type == 'Student'
        student_driving_school = StudentDrivingSchool.create!(student: invited_user, driving_school: driving_school)
        student_driving_school.create_invitation!(invited_user_params) unless invited_user
      end

      # Information about cooperation request
      InvitationMailer.cooperation_email(
        invited_user_params[:email],
        invited_user_type,
        invited_user.present?,
        driving_school
      ).deliver
    end
  end

  private

  def validate_invited_user_type
    raise ActiveRecord::SubclassNotFound unless User::TYPES.include?(invited_user_type)
  end

  def validate_type_to_match_invited_user
    raise ArgumentError.new('Invited user already exists but with different role.') if invited_user && invited_user.type != invited_user_type
  end

  def validate_if_already_invited
    relation = EmployeeDrivingSchool.find_by(driving_school: driving_school, employee: invited_user) || StudentDrivingSchool.find_by(driving_school: driving_school, student: invited_user)
    raise ArgumentError.new('User is already invited.') if relation&.pending?
    raise ArgumentError.new('User is already related with this school.') if relation&.active?
  end

  attr_reader :driving_school, :invited_user_type, :invited_user_params, :invited_user_privileges_params, :invited_user
end
