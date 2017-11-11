module ErrorsHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::SubclassNotFound, with: :invalid_user_type

    private

    def invalid_user_type
      render json: { type: ['must by either Student or Employee'] }, status: 422
    end
  end
end
