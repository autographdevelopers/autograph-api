class Api::V1::StudentsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:index]
  before_action :set_driving_school

  def index
    if current_user.is_owner?(@driving_school) || current_user.can_manage_students?(@driving_school)
      @student_driving_schools = @driving_school.student_driving_schools.includes(:student, :invitation).order('users.surname')
    else
      # change to scope to students who had driving lessons with given employee
      @student_driving_schools = @driving_school.student_driving_schools.includes(:student).active.order('users.surname')
    end
  end

  private

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:driving_school_id])
  end
end
