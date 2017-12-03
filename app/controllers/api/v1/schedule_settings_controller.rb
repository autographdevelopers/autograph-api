class Api::V1::ScheduleSettingsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:update]
  before_action :set_schedule_setting

  def update
    authorize @schedule_setting

    if @schedule_setting.update(schedule_setting_params)
      render @schedule_setting, status: :ok
    else
      render json: @schedule_setting.errors, status: :unprocessable_entity
    end
  end

  private

  def schedule_setting_params
    params.require(:schedule_setting).permit(:holidays_enrollment_enabled, :last_minute_booking_enabled)
  end

  def set_schedule_setting
    @schedule_setting = current_user.driving_schools.find(params[:driving_school_id]).schedule_setting
  end
end
