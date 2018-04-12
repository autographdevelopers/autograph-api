class Api::V1::ActivitiesController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: :index
  before_action :set_driving_school
  after_action :set_as_read, only: :my_activities

  def my_activities
    @notifiable_user_activities = current_user.notifiable_user_activities
                                              .includes(:activity)
                                              .where(activities: { driving_school_id: @driving_school.id })
                                              .order('activities.created_at DESC')
                                              .page(params[:page])
  end

  # Add authorization
  def index
    @activities = @driving_school.activities
                                 .related_to_user(related_user_id)
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

  def related_user_id
    params.require(:related_user_id)
  end

  # Reason for using `pluck(:id)`
  # https://github.com/rails/rails/issues/30148
  def set_as_read
    NotifiableUserActivity.where(id: @notifiable_user_activities.pluck(:id))
                          .update_all(read: true)
  end
end
