class Api::V1::CoursesController < ApplicationController
  has_scope :kept, type: :boolean, only: :index
  has_scope :discarded, type: :boolean, only: :index

  before_action :authorize_action
  before_action :set_employee_school
  before_action :set_school
  before_action :set_course, only: %i[update archive]

  def index
    @courses = @school.courses
    @courses = apply_scopes(@courses)
    @courses = policy_scope(@courses)
    @courses = @courses.order('courses.created_at DESC')
    @courses = @courses.includes(:course_type)
    @courses = @courses.page(params[:page]).per(records_per_page)
  end

  def create
    @course = @school.courses.create!(course_params)
  end

  def update
    @course.update!(course_params)
  end

  def archive
    @course.discard!
  end

  private

  def course_params
    params.require(:course).permit(
      :name,
      :description,
      :course_participations_limit,
      :course_type_id
    )
  end

  def set_employee_school
    @employee_school = current_user.user_driving_schools
                                   .active_with_active_driving_school
                                   .find_by!(driving_school_id: params[:driving_school_id])
  end

  def set_school
    @school = @employee_school.driving_school
  end

  def set_course
    @course = @school.courses.find(params[:id])
  end

  def authorize_action
    authorize Course
  end
end
