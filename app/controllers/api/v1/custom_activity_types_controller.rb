class Api::V1::CustomActivityTypesController < ApplicationController
  before_action :set_driving_school
  before_action :set_custom_activity, only: %i[discard update]

  def create
    @custom_activity_type = @driving_school.custom_activity_types.create!(custom_activity_params)
  end

  def update
    @custom_activity_type.update!(custom_activity_params)
  end

  def discard
    @custom_activity_type.discard!
  end

  def index
    @custom_activity_types = @driving_school.custom_activity_types
  end

  private

  def custom_activity_params
    params.require(:custom_activity_type).permit(
      :name,
      :message_template,
      :target_type,
      :notification_receivers,
      :datetime_input_config,
      :text_note_input_config
    )
  end

  def set_driving_school
    @driving_school = current_user.employee_driving_schools
      .active_with_active_driving_school
      .find_by!(driving_school_id: params[:driving_school_id])
      .driving_school
  end

  def set_custom_activity
    @custom_activity_type = @driving_school.custom_activity_types.find(params[:id])
  end
end
