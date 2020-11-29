class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  skip_before_action :authenticate_api_v1_user!, only: :create

  protected

  def render_create_success
    sleep 1
    render :create
  end
end
