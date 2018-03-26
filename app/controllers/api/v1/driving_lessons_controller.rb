class Api::V1::DrivingLessonsController < ApplicationController
  before_action :set_driving_school
  before_action :set_driving_lesson, only: [:cancel]
  before_action :set_employee_driving_school, only: [:create]
  before_action :set_student, only: [:create]
  before_action :set_slots, only: [:create]

  has_scope :student_id
  has_scope :employee_id
  has_scope :driving_lessons_ids, type: :array

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

  def create
    @driving_lesson = DrivingLessons::BuildService.new(
      current_user, @employee_driving_school.employee, @student, @driving_school, @slots
    ).call

    authorize @driving_lesson

    if @driving_lesson.save
      render :create, status: :created
    else
      render json: @driving_lesson.errors, status: :unprocessable_entity
    end
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

  def set_employee_driving_school
    @employee_driving_school = @driving_school.employee_driving_schools
                                              .active
                                              .find_by!(employee_id: params[:employee_id])
  end

  def set_student
    @student = @driving_school.student_driving_schools
                              .active
                              .find_by!(student_id: params[:student_id])
                              .student
  end

  def set_slots
    @slots = @employee_driving_school.slots
                                     .available
                                     .find(params[:slot_ids])
  end
end
