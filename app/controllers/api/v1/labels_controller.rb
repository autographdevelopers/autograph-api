class Api::V1::LabelsController < ApplicationController
  has_scope :purpose_course_category, type: :boolean
  has_scope :prebuilt, type: :boolean
  has_scope :label_ids, type: :array

  def index
    @labels = apply_scopes(Label.all)
    render json: @labels
  end
end
