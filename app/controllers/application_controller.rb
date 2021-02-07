class ApplicationController < ActionController::API
  include ErrorsHandlers
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  before_action :authenticate_api_v1_user!
  helper_method :current_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  # skip_before_action :authenticate_api_v1_user!, if: :devise_controller?
  helper_method :protect_against_forgery?
  after_action { puts response.body }

  DEFAULT_RECORDS_PER_PAGE = 20

  def current_user
    current_api_v1_user
  end

  protected

  def records_per_page
    params[:per] || DEFAULT_RECORDS_PER_PAGE
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name, :surname, :birth_date, :gender, :type, :time_zone
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :name, :surname, :email
    ])
  end

  def verify_current_user_to_be_employee
    authorize current_user, :employee?
  end

  def verify_current_user_to_be_student
    authorize current_user, :student?
  end

  def protect_against_forgery?
    # without this set password form from invitation email does not work
    false
  end
end
