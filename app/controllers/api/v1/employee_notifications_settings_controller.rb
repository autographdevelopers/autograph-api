class Api::V1::EmployeeNotificationsSettingsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:update, :show]
  before_action :set_employee_notifications_settings, only: [:update, :show]

  def update
    authorize @employee_notifications_settings

    if @employee_notifications_settings.update(employee_notifications_settings_params)
      render @employee_notifications_settings
    else
      render json: @employee_notifications_settings.errors, status: :unprocessable_entity
    end
  end

  def show
    authorize @employee_notifications_settings

    render @employee_notifications_settings
  end

  private

  def employee_notifications_settings_params
    params.require(:employee_notifications_settings).permit(
      :push_notifications_enabled,
      :weekly_emails_reports_enabled,
      :monthly_emails_reports_enabled
    )
  end

  def set_employee_notifications_settings
    @employee_notifications_settings = current_user.employee_driving_schools.find_by!(
      driving_school_id: params[:driving_school_id]
    ).employee_notifications_settings
  end
end
