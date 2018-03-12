class Api::V1::ScheduleSettingsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:update, :show]
  before_action :set_schedule_settings, only: [:update, :show]

  def update
    authorize @schedule_settings

    if @schedule_settings.update(schedule_settings_params)
      render @schedule_settings, status: :ok
    else
      render json: @schedule_settings.errors, status: :unprocessable_entity
    end
  end

  def show
    authorize @schedule_settings

    render @schedule_settings
  end

  private

  def schedule_settings_params
    params.require(:schedule_settings).permit(:holidays_enrollment_enabled, :last_minute_booking_enabled)
  end

  def set_schedule_settings
    @schedule_settings = current_user.driving_schools.find(params[:driving_school_id]).schedule_settings
  end
end
