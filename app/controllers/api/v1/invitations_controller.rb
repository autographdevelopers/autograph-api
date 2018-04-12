class Api::V1::InvitationsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:create, :destroy]
  before_action :set_driving_school, only: [:create, :destroy]
  before_action :set_invited_user_type, only: [:create]
  before_action :set_user_driving_school, onyl: [:accept, :reject]

  def create
    authorize @driving_school, :can_manage_employees? if @invited_user_type == User::EMPLOYEE
    authorize @driving_school, :can_manage_students? if @invited_user_type == User::STUDENT

    @user_driving_school_relation = Invitations::CreateService.new(
      @driving_school,
      @invited_user_type,
      invited_user_params,
      invited_employee_privileges_params
    ).call

    create_activity(@user_driving_school_relation)

    render :create, status: :created
  end

  def accept
    @user_driving_school.activate!
    create_activity(@user_driving_school)

    render 'api/v1/driving_schools/show', locals: {
      user_driving_school: @user_driving_school
    }
  end

  def reject
    @user_driving_school.reject!
    create_activity(@user_driving_school)
  end

  def destroy
    authorize @driving_school, :can_manage_employees? if params[:type] == User::EMPLOYEE
    authorize @driving_school, :can_manage_students? if params[:type] == User::STUDENT

    user_driving_school = Invitations::DestroyService.new(
      invitation_id: params[:user_id],
      invited_user_type: params[:type],
      driving_school: @driving_school
    ).call

    create_activity(user_driving_school)
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
    @driving_school = current_user.employee_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end

  def set_user_driving_school
    @user_driving_school = current_user.user_driving_schools.find_by!(
      driving_school_id: params[:driving_school_id]
    )
  end

  def create_activity(target)
    Activity.create(
      user: current_user,
      driving_school: target.driving_school,
      activity_type: determine_activity_type(target),
      target: target
    )
  end

  def determine_activity_type(target)
    prefix = if target.is_a? EmployeeDrivingSchool
               'employee'
             elsif target.is_a? StudentDrivingSchool
               'student'
             end

    suffix = {
      'create' => 'invitation_sent',
      'accept' => 'invitation_accepted',
      'reject' => 'invitation_rejected',
      'destroy' => 'invitation_withdrawn'
    }[action_name]

    "#{prefix}_#{suffix}".to_sym
  end
end
