class Invitations::DestroyService
  def initialize(driving_school:, invited_user_type:, invitation_id:)
    @driving_school = driving_school
    @invited_user_type = invited_user_type
    @invitation_id = invitation_id

    validate_invited_user_type
  end

  def call
    user_driving_school.archive!
  end

  private

  attr_reader :driving_school, :invited_user_type, :invitation_id

  def validate_invited_user_type
    raise ActiveRecord::SubclassNotFound unless User::TYPES.include?(invited_user_type)
  end

  def user_driving_school
    if invited_user_type == User::EMPLOYEE
      @driving_school.employee_driving_schools
                     .left_outer_joins(:invitation)
                     .find_by!(
                       '"employee_driving_schools"."employee_id" = :invitation_id OR "invitations"."id" = :invitation_id',
                       invitation_id: invitation_id.to_i
                     )
    elsif invited_user_type == User::STUDENT
      @driving_school.student_driving_schools
                     .left_outer_joins(:invitation)
                     .find_by!(
                       '"student_driving_schools"."student_id" = :invitation_id OR "invitations"."id" = :invitation_id',
                       invitation_id: invitation_id.to_i
                     )
    end
  end
end