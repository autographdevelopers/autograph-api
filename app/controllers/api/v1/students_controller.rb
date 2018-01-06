class Api::V1::StudentsController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: [:index]
  before_action :set_driving_school

  def index
    if current_user.can_manage_students?(@driving_school)
      @students = @driving_school.students
    else
      # change to scope to students who had driving lessons with given employee
      @students = @driving_school.students
    end
  end

  private

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:driving_school_id])
  end
end
