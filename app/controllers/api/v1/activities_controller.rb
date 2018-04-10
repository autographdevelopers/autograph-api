class Api::V1::ActivitiesController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: :index
  before_action :set_driving_school
  after_action :set_as_read, only: :my_activities

  has_scope :related_user_id
  has_scope :maker_id

  def my_activities
    @user_activities = current_user.user_activities
                                   .includes(:activity)
                                   .where(activities: { driving_school_id: @driving_school.id })
                                   .order('activities.created_at DESC')
                                   .page(params[:page])
  end

  def index
    @activities = apply_scopes(@driving_school.activities)
                    .order('activities.created_at DESC')
                    .page(params[:page])
  end

  private

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end

  def set_as_read
    UserActivity.where(id: @user_activities.pluck(:id))
                .update_all(read: true)
  end
end
