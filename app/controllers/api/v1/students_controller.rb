class Api::V1::StudentsController < ApplicationController
  before_action :verify_current_user_to_be_employee
  before_action :set_employee_driving_school
  has_scope :active_with_active_driving_school, as: :active, type: :boolean
  has_scope :pending_with_active_driving_school, as: :pending, type: :boolean
  has_scope :archived_with_active_driving_school, as: :archived, type: :boolean
  has_scope :searchTerm

  def index
    employee_privileges = @employee_driving_school.employee_privileges

    if employee_privileges.is_owner? || employee_privileges.can_manage_students?
      @student_driving_schools = @employee_driving_school.driving_school
                                                         .student_driving_schools
                                                         .includes(:student, :invitation, :course_participation_details)
                                                         .order(:id)
                                                         .page(params[:page])
                                                         .per(params[:per] || 20)

    else
      @student_driving_schools = StudentDrivingSchool.none
    end
    @student_driving_schools = apply_scopes(@student_driving_schools)
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
