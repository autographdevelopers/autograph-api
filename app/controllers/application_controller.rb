class ApplicationController < ActionController::API
  include ErrorsHandlers
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_api_v1_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :authenticate_api_v1_user!, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name, :surname, :birth_date, :gender, :type, :time_zone
    ])
  end
end
