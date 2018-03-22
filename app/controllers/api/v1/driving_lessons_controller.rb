class Api::V1::DrivingLessonsController < ApplicationController
  before_action :set_driving_school
  before_action :set_driving_lesson, only: [:cancel]

  def index
    @driving_lessons = DrivingLesson.where(
      employee_id: employee_id,
      student_id: student_id,
      driving_school_id: @driving_school.id
    ).active.upcoming.includes(:slots)
  end

  def cancel
    # authorize @driving_lesson

    DrivingLessons::CancelService.new(current_user, @driving_lesson).call

    render @driving_lesson
  end

  private

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end

  def set_driving_lesson
    @driving_lesson = DrivingLesson.by_driving_school(@driving_school.id)
                                   .upcoming
                                   .find(params[:id])
  end

  def employee_id
    current_user.employee? ? params[:employee_id] : nil
  end

  def student_id
    current_user.employee? ? params[:student_id] : current_user.id
  end
end
