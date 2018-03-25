class Api::V1::SlotsController < ApplicationController
  before_action :set_driving_school
  before_action :set_employee_driving_school

  has_scope :by_start_time, using: [:from, :to], type: :hash

  def index
    @slots = apply_scopes(@employee_driving_school.slots)
  end

  private

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end

  def set_employee_driving_school
    @employee_driving_school = @driving_school.employee_driving_schools
                                              .find_by!(employee_id: params[:employee_id])
  end
end
