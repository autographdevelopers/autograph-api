class Api::V1::TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  skip_before_action :authenticate_api_v1_user!

  def render_validate_token_success
    render :validate_token
  end
end
