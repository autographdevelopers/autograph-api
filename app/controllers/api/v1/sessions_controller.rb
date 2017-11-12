class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  protected

  def render_create_success
    render :create
  end
end
