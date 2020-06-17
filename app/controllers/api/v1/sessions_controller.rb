class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  protected

  def render_create_success
    # sleep 1
    render :create
  end
end
