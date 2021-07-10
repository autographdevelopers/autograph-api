class Api::V1::StudentsController < ApplicationController
  before_action :verify_current_user_to_be_employee
  before_action :set_employee_driving_school
  has_scope :ones_not_assigned_to_course, as: :ones_not_assigned_to_course
  has_scope :search, as: 'search-term'
  has_scope :with_status_in_active_school, as: :status

  def index
    employee_privileges = @employee_driving_school.employee_privileges

    if employee_privileges.is_owner? || employee_privileges.can_manage_students?
      @student_driving_schools = @employee_driving_school.driving_school
                                                         .student_driving_schools
                                                         .includes(:student)
                                                         .references(:student)
                                                         .order(:id)
                                                         .page(params[:page])
                                                         .per(params[:per] || 20)

    else
      @student_driving_schools = StudentDrivingSchool.none
    end
    @student_driving_schools = apply_scopes(@student_driving_schools)
  end

  def show
    @student_driving_school = @employee_driving_school.driving_school.student_driving_schools.find_by(student_id: params[:id])
  end

  def not_assigned_to_course

    participation_student_driving_schools = @employee_driving_school.driving_school.course_participation_details.kept.where(course_id: params[:course_id]).pluck(:student_driving_school_id)

    @student_driving_schools = @employee_driving_school
      .driving_school
      .student_driving_schools
      .where.not(id: participation_student_driving_schools)
      .includes(:student)
      .references(:student)
      .page(params[:page])
      .per(params[:per] || 20)

    @student_driving_schools = apply_scopes(@student_driving_schools)

    render :index
  end

  private

  def set_employee_driving_school
    @employee_driving_school = current_user.employee_driving_schools
                                           .active_with_active_driving_school
                                           .find_by!(
                                             driving_school_id: params[:driving_school_id]
                                           )
  end
end
