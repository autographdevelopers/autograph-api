class Api::V1::InvitationsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:create]
  before_action :set_driving_school, onyl: [:create]
  before_action :set_invited_user_type, only: [:create]
  before_action :set_user_driving_school, onyl: [:accept, :reject]

  def create
    authorize @user_driving_school, :can_manage_employees? if @invited_user_type == User::EMPLOYEE
    authorize @user_driving_school, :can_manage_students? if @invited_user_type == User::STUDENT

    @user_driving_school_relation = CreateInvitationService.new(
      @driving_school,
      @invited_user_type,
      invited_user_params,
      invited_employee_privileges_params
    ).call

    render :create, status: :created
  end

  def accept
    @user_driving_school.activate!

    render 'api/v1/driving_schools/show', locals: {
      user_driving_school: @user_driving_school
    }
  end

  def reject
    @user_driving_school.reject!
  end

  private

  def invited_user_params
    params.require(:user).permit(:email, :name, :surname)
  end

  def set_invited_user_type
    @invited_user_type = params.require(:user).permit(:type)[:type]
  end

  def invited_employee_privileges_params
    if @invited_user_type == User::EMPLOYEE
      params.require(:employee_privileges).permit(
        :can_manage_employees,
        :can_manage_students,
        :can_modify_schedules,
        :is_driving
      )
    end
  end

  def set_driving_school
    @driving_school = current_user.driving_schools.find(
      params[:driving_school_id]
    )
  end

  def set_user_driving_school
    @user_driving_school = current_user.user_driving_schools.find_by!(
      driving_school_id: params[:driving_school_id]
    )
  end
end
