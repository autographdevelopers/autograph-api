class Api::V1::SchedulesController < ApplicationController
  before_action :verify_current_user_to_be_employee
  before_action :set_driving_school
  before_action :set_employee_driving_school
  before_action :set_schedule
  before_action :sanitize_slots_ids

  def update
    authorize @schedule

    Slot.transaction do
      @schedule.update!(schedule_params)
      ScheduleSlotsService.new(@schedule).call
    end

    render @schedule
  end

  private

  def schedule_params
    params.require(:schedule).permit(
      :repetition_period_in_weeks,
      :new_template_binding_from,
      current_template: {
        monday: [],
        tuesday: [],
        wednesday: [],
        thursday: [],
        friday: [],
        saturday: [],
        sunday: []
      },
      new_template: {
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

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:driving_school_id])
  end

  def set_employee_driving_school
    @employee_driving_school = @driving_school.employee_driving_schools.find_by!(employee_id: params[:employee_id])
  end

  def set_schedule
    @schedule = @employee_driving_school.schedule
  end

  def sanitize_slots_ids
    [:current_template, :new_template].each do |template|
      params[:schedule][template] = schedule_params[template].transform_values do |slots_ids|
        slots_ids.reject { |id| id.empty? }.map { |id| id.to_i }
      end
    end
  end
end
