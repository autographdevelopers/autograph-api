class Api::V1::CourseParticipationsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:update]
  before_action :set_driving_school
  before_action :set_student_school
  before_action :set_course_participation, only: [:update, :show]

  def index
    @course_participations = @student_school.course_participations.includes(:course)
  end

  def show
    authorize @course_participation

    render @course_participation
  end

  def update
    authorize @driving_school, :can_manage_students?

    if @course_participation.update(course_participation_params)
      create_activity
      render @course_participation
    else
      render json: @course_participation.errors, status: :unprocessable_entity
    end
  end

  def create
    authorize @driving_school, :can_manage_students?

    @student_school.update!(driving_courses_params)

    head :ok
  end

  private

  def course_participation_params
    params.require(:course_participation).permit(:available_hours)
  end

  def driving_courses_params
    params.require(:employee_driving_school).permit(
      driving_courses_attributes: %i[available_hours]
    )
  end

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end

  def set_student_school
    @student_school = @driving_school.student_driving_schools
                          .active
                          .find_by!(student_id: params[:student_id])
  end

  def set_course_participation
    @course_participation = @student_school.course_participations.find(params[:id])
  end

  def create_activity
    Activity.create(
      user: current_user,
      driving_school: @driving_school,
      activity_type: :driving_course_changed,
      target: @course_participation
    )
  end
end
