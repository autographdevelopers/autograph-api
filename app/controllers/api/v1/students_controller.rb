class Api::V1::StudentsController < ApplicationController
  before_action :verify_current_user_to_be_employee
  before_action :set_employee_driving_school

  def index
    employee_privileges = @employee_driving_school.employee_privileges

    if employee_privileges.is_owner? || employee_privileges.can_manage_students?
      @student_driving_schools = @employee_driving_school.driving_school
                                                         .student_driving_schools
                                                         .where(status: [:pending, :active])
                                                         .includes(:student, :invitation)
                                                         .order('users.surname')
    else
      @student_driving_schools = @employee_driving_school.student_driving_schools
                                                         .active
                                                         .includes(:student)
    end
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
