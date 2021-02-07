class Api::V1::UserDrivingSchoolsController < ApplicationController
  before_action :set_driving_school

  def employee_exists_with_email
    find_user_school_relation!(@driving_school.employee_driving_schools)
    head :ok
  end

  def student_exists_with_email
    find_user_school_relation!(@driving_school.student_driving_schools)
    head :ok
  end

  private

  def find_user_school_relation!(user_schools)
    user_schools.joins(:student, :invitations)
                .find_by!(
                  'users.email = :email',
                  email: params[:email]
                )
  end

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end
end
