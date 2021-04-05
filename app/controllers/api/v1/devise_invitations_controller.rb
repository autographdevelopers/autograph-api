class Api::V1::DeviseInvitationsController < Devise::InvitationsController
  include InvitableMethods
  # before_action :authenticate_user!, only: :create
  before_action :authenticate_api_v1_user!, only: :create
  skip_before_action :authenticate_api_v1_user!, on: :update

  before_action :resource_from_invitation_token, only: [:edit, :update]


  # TODO merge this controller with our custom invitations controller
  # def create
  #   User.invite!(invite_params, current_user)
  #   render json: { success: ['User created.'] }, status: :created
  # end

  # def edit
  #   redirect_to "#{client_api_url}?invitation_token=#{params[:invitation_token]}"
  # end
  #
  def edit
    sign_out send("current_#{resource_name}") if send("#{resource_name}_signed_in?")
    set_minimum_password_length
    resource.invitation_token = params[:invitation_token]
    redirect_to Rails.application.secrets.fe_app_host + "/sign-up-from-invitation?invitation_token=#{params[:invitation_token]}"
  end

  def update
    @user = User.accept_invitation!(accept_invitation_params)
    if @user.errors.empty?
      render json: { success: ['User updated.'] }, status: :accepted
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def invite_params
    params.permit(user: [:email, :invitation_token, :provider, :skip_invitation])
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end
end
