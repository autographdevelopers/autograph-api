class Api::V1::DrivingSchoolsController < ApplicationController
  def index
    @driving_schools = build_results(policy_scope(DrivingSchool))
  end

  private

  def build_results(driving_schools)
    driving_schools_with_configurations_set = []

    if current_user.employee?
      driving_schools.each do |driving_school|
        driving_school_with_configuration = {}
        driving_school_with_configuration[:basic_information] = driving_school
        employee_driving_school = current_user.employee_driving_schools.find_by(driving_school: driving_school)
        driving_school_with_configuration[:employee_driving_school_status] = employee_driving_school.status
        driving_school_with_configuration[:employee_privilege_set] = employee_driving_school.employee_privilege_set
        driving_schools_with_configurations_set << driving_school_with_configuration
      end
    elsif current_user.student?
      driving_schools.each do |driving_school|
        driving_school_with_configuration = {}
        driving_school_with_configuration[:basic_information] = driving_school
        student_driving_school = current_user.student_driving_schools.find_by(driving_school: driving_school)
        driving_school_with_configuration[:student_driving_school_status] = student_driving_school.status
        driving_schools_with_configurations_set << driving_school_with_configuration
      end
    end

    driving_schools_with_configurations_set
  end
end