class Api::V1::DrivingLessonsController < ApplicationController
  before_action :set_driving_school
  before_action :set_driving_lesson, only: [:cancel]
  before_action :set_employee_driving_school, only: [:create]
  before_action :set_student, only: [:create]
  before_action :set_slots, only: [:create]

  has_scope :student_id
  has_scope :employee_id
  has_scope :driving_lessons_ids, type: :array
  has_scope :active, type: :boolean
  has_scope :canceled, type: :boolean
  has_scope :upcoming, type: :boolean
  has_scope :past, type: :boolean
  has_scope :from_date_time
  has_scope :to_date_time

  def index
    sleep 2
    @driving_lessons = apply_scopes(
      policy_scope(@driving_school.driving_lessons)
    ).includes(:employee, :student, :driving_school,
               slots: :employee_driving_school).page(params[:page]).per(params[:per] || 20)
  end

  def cancel
    authorize @driving_lesson

    DrivingLessons::CancelService.new(current_user, @driving_lesson).call
    create_activity

    render @driving_lesson
  end

  def create

    @driving_lesson = DrivingLessons::BuildService.new(
      current_user,
      @employee_driving_school,
      @student,
      @driving_school,
      @slots,
      @course_participation
    ).call

    authorize @driving_lesson

    if @driving_lesson.save
      create_activity
      render :create, locals: {
        driving_lesson: @driving_lesson
      }, status: :created
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

  def set_driving_course_participation
    @course_participation = @driving_school
                        .student_driving_schools
                        .active
                        .find_by!(student_id: params[:student_id])
                        .course_participations.find(params[:course_participation_id])
  end

  def set_employee_driving_school
    sleep 3
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

  def create_activity
    Activity.create(
      user: current_user,
      driving_school: @driving_school,
      activity_type: determine_activity_type,
      target: @driving_lesson
    )
  end

  def determine_activity_type
    suffix = {
      'create' => 'scheduled',
      'cancel' => 'canceled'
    }[action_name]

    "driving_lesson_#{suffix}".to_sym
  end
end
