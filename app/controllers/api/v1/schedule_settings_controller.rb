class Api::V1::ScheduleSettingsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:update]
  before_action :set_schedule_settings, only: [:update, :show]
  before_action :sanitize_slots_ids, only: [:update]

  def update
    authorize @schedule_settings

    if @schedule_settings.update(schedule_settings_params)
      render @schedule_settings, status: :ok
    else
      render json: @schedule_settings.errors, status: :unprocessable_entity
    end
  end

  def show
    render @schedule_settings
  end

  private

  def schedule_settings_params
    params.require(:schedule_settings).permit(
      :holidays_enrollment_enabled,
      :last_minute_booking_enabled,
      :minimum_slots_count_per_driving_lesson,
      :maximum_slots_count_per_driving_lesson,
      :can_student_book_driving_lesson,
      :booking_advance_period_in_weeks,
      valid_time_frames: {
        monday: [],
        tuesday: [],
        wednesday: [],
        thursday: [],
        friday: [],
        saturday: [],
        sunday: []
      }
    )
  end

  def set_schedule_settings
    @schedule_settings = current_user.driving_schools.find(
      params[:driving_school_id]
    ).schedule_settings
  end

  def sanitize_slots_ids
    return if schedule_settings_params[:valid_time_frames].blank?
    params[:schedule_settings][:valid_time_frames] = schedule_settings_params[:valid_time_frames].transform_values do |slots_ids|
      slots_ids.reject { |id| id.blank? }.map { |id| id.to_i }
    end
  end
end
