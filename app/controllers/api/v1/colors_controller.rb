class Api::V1::ColorsController < ApplicationController
  def index
    sleep 2
    render json: Color.all
  end
end
