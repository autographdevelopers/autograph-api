class Api::V1::UsersController < DeviseTokenAuth::RegistrationsController
  protected

  def render_create_success
    render :create
  end

  def render_create_error
    render json: @resource.errors, status: :unprocessable_entity
  end
end
