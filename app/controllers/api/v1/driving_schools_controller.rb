class Api::V1::DrivingSchoolsController < ApplicationController
  def index
    @driving_schools = policy_scope(DrivingSchool)
  end
end
