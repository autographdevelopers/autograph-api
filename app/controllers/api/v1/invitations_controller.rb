class Api::V1::InvitationsController < ApplicationController
  before_action :verify_current_user_to_be_employee
  before_action :set_driving_school

  def create
    authorize @driving_school, :can_manage_employees? if invited_user_type == 'Employee'
    authorize @driving_school, :can_manage_students? if invited_user_type == 'Student'

    CreateInvitationService.new(
      @driving_school,
      invited_user_type,
      invited_user_params,
      invited_user_privileges_params
    ).call

    head :created
  end

  private

  def invited_user_params
    params.require(:user).permit(:email, :name, :surname)
  end

  def invited_user_type
    params.require(:user).permit(:type)[:type]
  end

  def invited_user_privileges_params
    params.require(:employee_privilege_set).permit(:can_manage_employees, :can_manage_students, :can_modify_schedules,
                                            :is_driving)
  end

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:driving_school_id])
  end
end