class Invitations::DestroyService
  def initialize(driving_school:, invited_user_type:, user_id:)
    @driving_school = driving_school
    @invited_user_type = invited_user_type
    @user_id = user_id

    validate_invited_user_type
  end

  def call
    user_driving_school.archived!
    user_driving_school
  end

  private

  attr_reader :driving_school, :invited_user_type, :user_id

  def validate_invited_user_type
    raise ActiveRecord::SubclassNotFound unless User::TYPES.include?(invited_user_type)
  end

  def user_driving_school
    if invited_user_type == User::EMPLOYEE
      @driving_school.employee_driving_schools.find_by!(employee_id: user_id)
    elsif invited_user_type == User::STUDENT
      @driving_school.student_driving_schools.find_by!(student_id: user_id)
    end
  end
end
