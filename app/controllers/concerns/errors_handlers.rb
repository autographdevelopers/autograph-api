module ErrorsHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::SubclassNotFound, with: :invalid_user_type
    rescue_from ActionController::RoutingError, with: :routes_not_found

    private

    def routes_not_found
      render json: { error: 'Route not found' }, status: :not_found
    end

    def invalid_user_type
      render json: { type: ['must by either Student or Employee'] }, status: :unprocessable_entity
    end
  end
end
