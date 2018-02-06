class Api::V1::EmployeePrivilegeSetsController < ApplicationController
  before_action :verify_current_user_to_be_employee
  before_action :set_driving_school
  before_action :set_employee_driving_school
  before_action :set_employee_privilege_set

  def update
    authorize @employee_privilege_set

    if @employee_privilege_set.update(employee_privilege_set_params)
      render @employee_privilege_set, status: :ok
    else
      render json: @employee_privilege_set.errors, status: :unprocessable_entity
    end
  end

  def show
    authorize @employee_privilege_set

    render @employee_privilege_set
  end

  private

  def employee_privilege_set_params
    params.require(:employee_privilege_set).permit(:can_manage_employees, :can_manage_students, :can_modify_schedules, :is_driving)
  end

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:driving_school_id])
  end

  def set_employee_driving_school
    @employee_driving_school = @driving_school.employee_driving_schools.find_by!(employee_id: params[:employee_id])
  end

  def set_employee_privilege_set
    @employee_privilege_set = @employee_driving_school.employee_privilege_set
  end
end
