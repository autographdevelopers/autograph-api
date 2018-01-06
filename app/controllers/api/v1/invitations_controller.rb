class Api::V1::InvitationsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:create]
  before_action :set_driving_school, onyl: [:create]
  before_action :set_invited_user_type, only: [:create]
  before_action :set_driving_school_relation, onyl: [:accept, :reject]

  def create
    authorize @driving_school, :can_manage_employees? if @invited_user_type == 'Employee'
    authorize @driving_school, :can_manage_students? if @invited_user_type == 'Student'

    CreateInvitationService.new(
      @driving_school,
      @invited_user_type,
      invited_user_params,
      invited_employee_privileges_params
    ).call

    head :created
  end

  def accept
    @driving_school_relation.activate!
  end

  def reject
    @driving_school_relation.reject!
  end

  private

  def invited_user_params
    params.require(:user).permit(:email, :name, :surname)
  end

  def set_invited_user_type
    @invited_user_type = params.require(:user).permit(:type)[:type]
  end

  def invited_employee_privileges_params
    if @invited_user_type == 'Employee'
      params.require(:employee_privilege_set).permit(:can_manage_employees, :can_manage_students, :can_modify_schedules,
                                                     :is_driving)
    end
  end

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:driving_school_id])
  end

  def set_driving_school_relation
    @driving_school_relation = current_user.get_relation(params[:driving_school_id])
  end
end
