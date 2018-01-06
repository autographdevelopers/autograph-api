class Api::V1::EmployeesController < ApplicationController
  before_action :set_driving_school

  def index
    if current_user.student?
      @employees = @driving_school.employees.where(employee_driving_schools: { status: :active })
    elsif current_user.employee?
      authorize @driving_school, :can_manage_employees?
      @employees = @driving_school.employees
    end
  end

  private

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:driving_school_id])
  end
end
