class Api::V1::CustomActivityTypesController < ApplicationController
  before_action :perform_user_based_authorization
  before_action :set_driving_school
  before_action :set_custom_activity, only: %i[discard update]

  def create
    @custom_activity_type = @driving_school.custom_activity_types.create!(custom_activity_params)
  end

  def update
    authorize @custom_activity_type
    @custom_activity_type.update!(custom_activity_params)
  end

  def discard
    authorize @custom_activity_type
    @custom_activity_type.discard!
    head :ok
  end

  def index
    @custom_activity_types = @driving_school.custom_activity_types.kept
  end

  def assert_test_activity
    @custom_activity_type = @driving_school.custom_activity_types.new(custom_activity_params)
    @custom_activity_type.init_test_activity(user: current_user)
    @custom_activity_type.validate!
    render partial: 'api/v1/activities/activity', locals: { activity: @custom_activity_type.test_activity }
  end

  private

  def custom_activity_params
    params.require(:custom_activity_type).permit(
      :title,
      :subtitle,
      :btn_bg_color,
      :message_template,
      :target_type,
      :notification_receivers,
      :datetime_input_config,
      :text_note_input_config,
      :datetime_input_instructions,
      :text_note_input_instructions,
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

  def perform_user_based_authorization
    authorize CustomActivityType
  end
end
