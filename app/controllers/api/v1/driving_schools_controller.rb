class Api::V1::DrivingSchoolsController < ApplicationController
  before_action :verify_current_user_to_be_employee, except: [:index, :show]
  before_action :set_employee_driving_school, except: [:index, :show, :create]
  before_action :set_driving_school, except: [:index, :show, :create]


  def index
    # sleep 2
    @user_driving_schools = current_user.user_driving_schools
                              .eligible_for_viewing
  end

  def show
    # sleep 2

    @user_driving_school = current_user.user_driving_schools
                             .eligible_for_viewing
                             .find_by!(driving_school_id: params[:id])

    render :show, locals: { user_driving_school: @user_driving_school }
  end

  def create
    @employee_driving_school = DrivingSchools::CreateService.new(
      current_user,
      driving_school_params
    ).call

    render :show, locals: {
      user_driving_school: @employee_driving_school
    }, status: :created
  end

  def update
    authorize @employee_driving_school, :is_owner?

    if @driving_school.update(driving_school_params)
      render :show, locals: { user_driving_school: @employee_driving_school }
    else
      render json: @driving_school.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @driving_school.destroy!
    head :ok
  end

  def confirm_registration
    authorize @employee_driving_school, :is_owner?

    @driving_school.confirm_registration!

    render :show, locals: { user_driving_school: @employee_driving_school }
  end

  def activate
    authorize @employee_driving_school, :is_owner?

    p "HEEEErk"
    if @driving_school.verification_code_valid?(params[:verification_code]) && @driving_school.activate!
      render :show, locals: { user_driving_school: @employee_driving_school }
    else
      p @driving_school.errors.full_messages
      render json: { verification_code: 'Provided verification code is invalid' }, status: :unprocessable_entity
    end
  end

  private

  def driving_school_params
    params.require(:driving_school).permit(
      :name,
      :website_link,
      :additional_information,
      :city,
      :zip_code, :street,
      :country,
      :profile_picture,
      :latitude,
      :longitude,
      :email,
      :phone_number,
    )
  end

  def set_employee_driving_school
    @employee_driving_school = current_user.employee_driving_schools.find_by!(driving_school_id: params[:id])
                                           # .active

  end

  def set_driving_school
    @driving_school = @employee_driving_school.driving_school
  end
end
