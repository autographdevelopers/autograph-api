class Api::V1::PasswordsController < DeviseTokenAuth::PasswordsController

  protected

  def render_update_success
    render partial: 'api/v1/users/user', locals: { user: @resource }
  end
end
