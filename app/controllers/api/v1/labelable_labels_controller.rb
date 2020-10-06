class Api::V1::LabelableLabelsController < ApplicationController
  before_action :set_labelable, only: :index

  has_scope :by_label_purpose

  def index
    # byebug
    @labelable_labels = apply_scopes(@labelable.labelable_labels.includes(:label))
  end

  private

  def set_labelable
    @labelable = if params[:driving_school_id]
                   # take from user
                   DrivingSchool.find(params[:driving_school_id])
                 end
  end
end
