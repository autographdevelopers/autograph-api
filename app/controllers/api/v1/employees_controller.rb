class Api::V1::EmployeesController < ApplicationController
  before_action :set_driving_school

  def index
    if current_user.student?
      @employee_driving_schools = @driving_school.employee_driving_schools.includes(:employee).where(status: :active)
    elsif current_user.employee?
      authorize @driving_school, :can_manage_employees?
      @employee_driving_schools = @driving_school.employee_driving_schools.includes(:employee, :invitation)
    end
  end

  private

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:driving_school_id])
  end
end
