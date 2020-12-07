class Api::V1::TagsController < ApplicationController
  before_action :set_taggable_model
  before_action :set_driving_school
  TAGGABLE_MODELS_ACCESS_LIST = [InventoryItem.name].freeze

  def model_tags
    @tags = @model.where(driving_school: @driving_school).tags_on(:tags)
  end

  private

  def set_taggable_model
    requested_model_name = TAGGABLE_MODELS_ACCESS_LIST.find do |model_name|
      params[:resources_name].singularize.classify == model_name
    end
    # byebug
    raise ActiveRecord::RecordNotFound unless requested_model_name
    @model = requested_model_name.constantize
  end

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                          .active_with_active_driving_school
                          .find_by!(driving_school_id: params[:driving_school_id])
                          .driving_school
  end
end
