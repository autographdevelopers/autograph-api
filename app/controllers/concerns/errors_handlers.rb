module ErrorsHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::SubclassNotFound, with: :invalid_user_type
    rescue_from ActionController::RoutingError, with: :routes_not_found
    rescue_from Pundit::NotAuthorizedError,     with: :not_authorized
    rescue_from ActiveRecord::RecordNotFound,   with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid,    with: :record_invalid

    private

    def routes_not_found
      render json: { error: 'Route not found' }, status: :not_found
    end

    def invalid_user_type
      render json: { type: ['must by either Student or Employee'] }, status: :unprocessable_entity
    end

    def not_authorized
      render json: { error: 'You are unauthorized to perform this action' }, status: :unauthorized
    end

    def record_invalid(e)
      render json: e.record.errors, status: :unprocessable_entity
    end

    def record_not_found(e)
      render json: { error: e.message }, status: :not_found
    end
  end
end
