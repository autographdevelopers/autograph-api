class Api::V1::EmployeePrivilegesController < ApplicationController
  before_action :verify_current_user_to_be_employee
  before_action :set_driving_school
  before_action :set_employee_driving_school
  before_action :set_employee_privileges

  def update
    authorize @employee_privileges

    if @employee_privileges.update(employee_privileges_params)
      render @employee_privileges
    else
      render json: @employee_privileges.errors, status: :unprocessable_entity
    end
  end

  def show
    authorize @employee_privileges

    render @employee_privileges
  end

  private

  def employee_privileges_params
    params.require(:employee_privileges).permit(
      :can_manage_employees,
      :can_manage_students,
      :can_modify_schedules,
      :is_driving
    )
  end

  def set_driving_school
    @driving_school = current_user.employee_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end

  def set_employee_driving_school
    @employee_driving_school = @driving_school.employee_driving_schools
                                              .find_by!(employee_id: params[:employee_id])
  end

  def set_employee_privileges
    @employee_privileges = @employee_driving_school.employee_privileges
  end
end
