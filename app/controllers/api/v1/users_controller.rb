class Api::V1::UsersController < DeviseTokenAuth::RegistrationsController
  skip_before_action :authenticate_api_v1_user!, only: :create

  def update_avatar
    current_user.avatar.purge
    current_user.avatar.attach(io: avatar_io, filename: 'XXXXX')
    render :update_avatar
  end

  def purge_avatar
    current_user.avatar.purge
    render :update_avatar
  end

  protected

  after_action :create_avatar_placeholder, only: :create

  def render_create_success
    render :create
  end

  def render_update_success
    render :update
  end

  def avatar_io
    decoded_image = Base64.decode64(params[:avatar_base64])
    StringIO.new(decoded_image)
  end

  def render_create_error
    render json: @resource.errors, status: :unprocessable_entity
  end

  private

  def create_avatar_placeholder
    @resource.create_avatar_placeholder_color!(application: :avatar_placeholder, hex_val: Color.pluck(:hex_val).sample) if @resource.persisted?
  end
end
