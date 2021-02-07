class Api::V1::StudentDrivingSchoolsController < ApplicationController
  def show
    @student_school = DrivingSchool.find(params[:driving_school_id])
      .student_driving_schools
      .left_joins(:student, :invitation)
      .find_by!(
        'users.email = :email',
        email: params[:email]
      )
  end
end
