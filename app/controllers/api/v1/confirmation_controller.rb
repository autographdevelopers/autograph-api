class Api::V1::ConfirmationController < ApplicationController
  def show
    @user = User.confirm_by_token(params[:confirmation_token])

    if @user.errors.empty?
      render json: 'Account confirmed', status: :accepted
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def create
    @user = User.with_email(params[:email]).first

    if @user && !@user.confirmed?
      @user.send_confirmation_instructions
    end

    head :no_content
  end
end
