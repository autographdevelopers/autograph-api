class Api::V1::SlotsController < ApplicationController
  before_action :set_driving_school

  has_scope :by_start_time, using: %i[from to], type: :hash
  has_scope :employee_id

  def index
    @slots = apply_scopes(
      Slot.includes(:employee_driving_school)
          .where(employee_driving_schools: {
                   driving_school_id: @driving_school.id
                 })
    )
  end

  private

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                                  .active_with_active_driving_school
                                  .find_by!(driving_school_id: params[:driving_school_id])
                                  .driving_school
  end
end
