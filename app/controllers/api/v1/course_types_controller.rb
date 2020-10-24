class Api::V1::CourseTypesController < ApplicationController
  before_action :set_employee_school
  before_action :set_school

  has_scope :only_prebuilts, type: :boolean, only: :index
  has_scope :reject_names, type: :array, only: :index
  has_scope :kept, type: :boolean, only: :index
  has_scope :discarded, type: :boolean, only: :index

  def index
    sleep 1
    authorize CourseType
    @course_types = CourseType.where(driving_school: params[:only_prebuilts] ? nil : @school).order(created_at: :desc)
    @course_types = apply_scopes(@course_types)
    # @course_types = @course_types .page(params[:page]).per(records_per_page)
  end

  private

  def set_employee_school
    @employee_school = current_user.user_driving_schools.find_by!(driving_school_id: params[:driving_school_id])
                           # .active_with_active_driving_school
  end

  def set_school
    @school = @employee_school.driving_school
  end
end
