# class Api::V1::EmployeesController
# index
# User can list employees only when he has active relation
# with driving school and driving school has active status.
# Student can browse only active Employees who can drive
# Employee with proper privileges can see invited and active Employees
# TODO Order employees to return those with whom student had driving lessons
class Api::V1::EmployeesController < ApplicationController
  before_action :set_driving_school
  has_scope :employee_ids, type: :array
  has_scope :with_status_in_active_school, as: :status
  has_scope :search, as: 'search-term'

  def index
    if current_user.student?
      @employee_driving_schools = @driving_school.employee_driving_schools
                                                 .active
                                                 .where(employee_privileges: { is_driving: true })
                                                 .includes(:employee, :employee_privileges)
                                                 .order('users.surname')
    elsif current_user.employee?
      authorize @driving_school, :can_manage_employees?

      @employee_driving_schools = @driving_school.employee_driving_schools
                                                 .includes(:employee, :employee_privileges)
                                                 .order('users.surname')
    end

    @employee_driving_schools = @employee_driving_schools.page(params[:page]).per(params[:per] || 20)

    @employee_driving_schools = apply_scopes(@employee_driving_schools)
  end

  def show
    @employee_driving_school = @driving_school.employee_driving_schools.find_by(employee_id: params[:id])
  end

  private

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end
end
