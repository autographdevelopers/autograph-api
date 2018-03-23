class Api::V1::DrivingLessonsController < ApplicationController
  before_action :set_driving_school
  before_action :set_driving_lesson, only: [:cancel]

  has_scope :student_id
  has_scope :employee_id

  def index
    @driving_lessons = apply_scopes(
      policy_scope(@driving_school.driving_lessons)
    ).active.upcoming.includes(:slots)
  end

  def cancel
    authorize @driving_lesson

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
    @driving_lesson = DrivingLesson.where(driving_school_id: @driving_school.id)
                                   .upcoming
                                   .find(params[:id])
  end
end
