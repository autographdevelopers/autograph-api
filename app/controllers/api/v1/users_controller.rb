class Api::V1::UsersController < DeviseTokenAuth::RegistrationsController
  protected

  after_action :create_avatar_placeholder, only: :create

  def render_create_success
    render :create
  end

  def render_update_success
    render :update
  end

  def render_create_error
    render json: @resource.errors, status: :unprocessable_entity
  end

  private

  def create_avatar_placeholder
    @resource.create_avatar_placeholder_color!(application: :avatar_placeholder, hex_val: Color.pluck(:hex_val).sample) if @resource.persisted?
  end
end
