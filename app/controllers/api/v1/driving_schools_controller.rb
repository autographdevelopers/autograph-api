class Api::V1::DrivingSchoolsController < ApplicationController
  before_action :verify_current_user_to_be_employee, except: [:index, :show]
  before_action :set_employee_driving_school, except: [:index, :show, :create]
  before_action :set_driving_school, except: [:index, :show, :create]


  def index
    # SOMETIME THIS RANDOMLY APPEARS IN RESPONSE
    # sleep 2
    # Started GET "/api/v1/driving_schools" for 127.0.0.1 at 2020-10-26 19:31:05 +0100
    # Processing by Api::V1::DrivingSchoolsController#index as JSON
    #   User Load (0.1ms)  SELECT  "users".* FROM "users" WHERE "users"."uid" = $1 LIMIT $2  [["uid", "undefined"], ["LIMIT", 1]]
    #   CACHE User Load (0.0ms)  SELECT  "users".* FROM "users" WHERE "users"."uid" = $1 LIMIT $2  [["uid", "undefined"], ["LIMIT", 1]]
    # Completed 500 Internal Server Error in 18ms (ActiveRecord: 0.1ms)
    #
    #
    #
    # NoMethodError (undefined method `user_driving_schools' for nil:NilClass):
    #
    # app/controllers/api/v1/driving_schools_controller.rb:9:in `index'
    # Started GET "/__webpack_hmr" for 127.0.0.1 at 2020-10-26 19:31:06 +0100
    #
    # ActionController::RoutingError (No route matches [GET] "/__webpack_hmr"):
    #
    # actionpack (5.1.6) lib/action_dispatch/middleware/debug_exceptions.rb:63:in `call'
    # actionpack (5.1.6) lib/action_dispatch/middleware/show_exceptions.rb:31:in `call'
    # railties (5.1.6) lib/rails/rack/logger.rb:36:in `call_app'
    # railties (5.1.6) lib/rails/rack/logger.rb:24:in `block in call'
    # activesupport (5.1.6) lib/active_support/tagged_logging.rb:69:in `block in tagged'
    # activesupport (5.1.6) lib/active_support/tagged_logging.rb:26:in `tagged'
    # activesupport (5.1.6) lib/active_support/tagged_logging.rb:69:in `tagged'
    # railties (5.1.6) lib/rails/rack/logger.rb:24:in `call'
    # actionpack (5.1.6) lib/action_dispatch/middleware/remote_ip.rb:79:in `call'
    # actionpack (5.1.6) lib/action_dispatch/middleware/request_id.rb:25:in `call'
    # rack (2.0.4) lib/rack/runtime.rb:22:in `call'
    # activesupport (5.1.6) lib/active_support/cache/strategy/local_cache_middleware.rb:27:in `call'
    # actionpack (5.1.6) lib/action_dispatch/middleware/executor.rb:12:in `call'
    # actionpack (5.1.6) lib/action_dispatch/middleware/static.rb:125:in `call'
    # rack (2.0.4) lib/rack/sendfile.rb:111:in `call'
    # railties (5.1.6) lib/rails/engine.rb:522:in `call'
    # puma (3.11.3) lib/puma/configuration.rb:225:in `call'
    # puma (3.11.3) lib/puma/server.rb:624:in `handle_request'
    # puma (3.11.3) lib/puma/server.rb:438:in `process_client'
    # puma (3.11.3) lib/puma/server.rb:302:in `block in run'
    # puma (3.11.3) lib/puma/thread_pool.rb:120:in `block in spawn_thread'
    @user_driving_schools = current_user.user_driving_schools.eligible_for_viewing
  end

  def show
    # sleep 2

    @user_driving_school = current_user.user_driving_schools
                             .eligible_for_viewing
                             .find_by!(driving_school_id: params[:id])

    render :show, locals: { user_driving_school: @user_driving_school }
  end

  def create
    @employee_driving_school = DrivingSchools::CreateService.new(
      current_user,
      driving_school_params
    ).call

    render :show, locals: {
      user_driving_school: @employee_driving_school
    }, status: :created
  end

  def update
    authorize @employee_driving_school, :is_owner?

    if @driving_school.update(driving_school_params)
      render :show, locals: { user_driving_school: @employee_driving_school }
    else
      render json: @driving_school.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @driving_school.discard!
    head :ok
  end

  def confirm_registration
    authorize @employee_driving_school, :is_owner?

    @driving_school.confirm_registration!

    render :show, locals: { user_driving_school: @employee_driving_school }
  end

  def activate
    authorize @employee_driving_school, :is_owner?

    p "HEEEErk"
    if @driving_school.verification_code_valid?(params[:verification_code]) && @driving_school.activate!
      render :show, locals: { user_driving_school: @employee_driving_school }
    else
      p @driving_school.errors.full_messages
      render json: { verification_code: 'Provided verification code is invalid' }, status: :unprocessable_entity
    end
  end

  private

  def driving_school_params
    params.require(:driving_school).permit(
      :name,
      :website_link,
      :additional_information,
      :city,
      :zip_code, :street,
      :country,
      :profile_picture,
      :latitude,
      :longitude,
      :email,
      :phone_number,
      course_types_attributes: [:id, :name, :description, :discarded_at]
    )
  end

  def set_employee_driving_school
    @employee_driving_school = current_user.employee_driving_schools.find_by!(driving_school_id: params[:id])
                                           # .active

  end

  def set_driving_school
    @driving_school = @employee_driving_school.driving_school
  end
end
