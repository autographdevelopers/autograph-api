class Api::V1::ScheduleSettingsSetsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:update, :show]
  before_action :set_schedule_settings_set, only: [:update, :show]

  def update
    authorize @schedule_settings_set

    if @schedule_settings_set.update(schedule_settings_set_params)
      render @schedule_settings_set, status: :ok
    else
      render json: @schedule_settings_set.errors, status: :unprocessable_entity
    end
  end

  def show
    authorize @schedule_settings_set

    render @schedule_settings_set
  end

  private

  def schedule_settings_set_params
    params.require(:schedule_settings_set).permit(:holidays_enrollment_enabled, :last_minute_booking_enabled)
  end

  def set_schedule_settings_set
    @schedule_settings_set = current_user.driving_schools.find(params[:driving_school_id]).schedule_settings_set
  end
end
