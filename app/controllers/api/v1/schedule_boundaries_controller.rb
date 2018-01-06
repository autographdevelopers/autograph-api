class Api::V1::ScheduleBoundariesController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:create]
  before_action :set_driving_school, only: [:create, :index]

  def create
    authorize @driving_school, :owner?

    CreateScheduleBoundariesService.new(@driving_school, schedule_boundaries_params).call

    @schedule_boundaries = @driving_school.schedule_boundaries

    render :index, status: :created
  end

  def index
    @schedule_boundaries = @driving_school.schedule_boundaries
  end

  private

  def schedule_boundaries_params
    params.require(:schedule_boundaries)
  end

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:driving_school_id])
  end
end
