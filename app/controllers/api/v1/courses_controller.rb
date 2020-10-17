class Api::V1::CoursesController < ApplicationController
  has_scope :status_active, as: :active, type: :boolean, only: :index
  has_scope :status_archived, as: :archived, type: :boolean, only: :index

  before_action :set_employee_school
  before_action :set_school

  def index
    @courses = @school.courses
    @courses = apply_scopes(@courses)
    @courses = policy_scope(@courses)
    @courses = @courses.order('courses.created_at DESC')
    @courses = @courses.includes(:course_type)
    @courses = @courses.page(params[:page]).per(records_per_page)
  end

  def create
  end

  def update
  end

  def archive
  end

  private

  def set_employee_school
    @employee_school = current_user.user_driving_schools
                                   .active_with_active_driving_school
                                   .find_by!(driving_school_id: params[:driving_school_id])
  end

  def set_school
    @school = @employee_school.driving_school
  end
end
