class Api::V1::EmployeeNotificationsSettingsSetsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:update]
  before_action :set_employee_notifications_settings_set, only: [:update]

  def update
    if @employee_notifications_settings_set.update(employee_notifications_settings_set_params)
      render @employee_notifications_settings_set, status: :ok
    else
      render json: @employee_notifications_settings_set.errors, status: :unprocessable_entity
    end
  end

  private

  def employee_notifications_settings_set_params
    params.require(:employee_notifications_settings_set).permit(
      :push_notifications_enabled, :weekly_emails_reports_enabled, :monthly_emails_reports_enabled
    )
  end

  def set_employee_notifications_settings_set
    @employee_notifications_settings_set = current_user.employee_driving_schools.find_by!(
      driving_school_id: params[:driving_school_id]
    ).employee_notifications_settings_set
  end
end
