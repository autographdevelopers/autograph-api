class CreateScheduleBoundariesService
  def initialize(driving_school, params)
    @driving_school = driving_school
    @params = params
  end

  def call
    ScheduleBoundary.transaction do
      params.each do |schedule_boundary_params|
        driving_school.schedule_boundaries.create!(
          weekday: schedule_boundary_params[:weekday],
          start_time: schedule_boundary_params[:start_time],
          end_time: schedule_boundary_params[:end_time]
        )
      end
    end
  end

  private

  attr_reader :params, :driving_school
end
