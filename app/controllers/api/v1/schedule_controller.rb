class Api::V1::ScheduleController < ApplicationController
  def update

  end

  private

  def schedule_params
    params.require(:schedule).permit(
      :repetition_period_in_weeks,

      monday: [],
      tuesday: [],
      wednesday: [],
      thursday: [],
      friday: [],
      saturday: [],
      sunday: []
    )
  end
end
