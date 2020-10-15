class Api::V1::CoursesController < ApplicationController
  has_scope :status_active, as: :active, type: :boolean, only: :index
  has_scope :status_archived, as: :archived, type: :boolean, only: :index

  before_action :set_employee_school
  before_action :set_school

  def index
    authorize @employee_school, :is_owner?
    @courses = @school.courses.order(created_at: :desc)
    @courses = apply_scopes(@courses)
    @courses = @courses.page(params[:page]).per(params[:per] || 25)
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
