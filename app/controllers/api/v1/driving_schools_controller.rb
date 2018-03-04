class Api::V1::DrivingSchoolsController < ApplicationController
  before_action :verify_current_user_to_be_employee, except: [:index, :show]
  before_action :set_driving_school, only: [:confirm_registration, :update, :show, :activate]

  def index
    @driving_schools = build_results(policy_scope(DrivingSchool))
  end

  def create
    @driving_school = CreateDrivingSchoolService.new(current_user, driving_school_params).call

    render @driving_school, status: :created
  end

  def update
    authorize @driving_school

    if @driving_school.update(driving_school_params)
      render @driving_school, status: :ok
    else
      render json: @driving_school.errors, status: :unprocessable_entity
    end
  end

  def confirm_registration
    authorize @driving_school

    @driving_school.confirm_registration!

    render @driving_school
  end

  def show
    if current_user.employee?
      @employee_driving_school = @current_user.employee_driving_schools.find_by(driving_school: @driving_school)
    elsif current_user.student?
      @student_driving_school = @current_user.student_driving_schools.find_by(driving_school: @driving_school)
    end
  end

  def activate
    authorize @driving_school

    if params[:verification_code] == @driving_school.verification_code
      @driving_school.activate!
      render @driving_school
    else
      render json: { error: 'Provided verification code is invalid' }, status: :forbidden
    end
  end

  private

  def driving_school_params
    params.require(:driving_school).permit(:name, :website_link, :additional_information, :city, :zip_code, :street,
                                           :country, :profile_picture, :latitude, :longitude, phone_numbers: [], emails: [])
  end

  def set_driving_school
    @driving_school = current_user.driving_schools.find(params[:id])
  end

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
