class Api::V1::DrivingCoursesController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:update]
  before_action :set_driving_school, only: [:update, :show]
  before_action :set_driving_course, only: [:update, :show]

  def show
    authorize @driving_course

    render @driving_course
  end

  def update
    authorize @driving_school, :can_manage_students?

    if @driving_course.update(driving_course_params)
      create_activity
      render @driving_course
    else
      render json: @driving_course.errors, status: :unprocessable_entity
    end
  end

  private

  def driving_course_params
    params.require(:driving_course).permit(
      :available_hours
    )
  end

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end

  def set_driving_course
    @driving_course = @driving_school.student_driving_schools
                                     .active
                                     .find_by!(student_id: params[:student_id])
                                     .driving_course
  end

  def create_activity
    Activity.create(
      user: current_user,
      driving_school: @driving_school,
      activity_type: :driving_course_changed,
      target: @driving_course
    )
  end
end
