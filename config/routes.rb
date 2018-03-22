Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/users',
        sessions: 'api/v1/sessions'
      }

      resources :driving_schools, only: [:index, :create, :update, :show] do
        member do
          put :confirm_registration
          put :activate
        end
        resources :invitations, only: [:create] do
          collection do
            put :accept
            put :reject
            delete :destroy
          end
        end
        resources :driving_lessons, only: [:index] do
          member do
            put :cancel
          end
        end
        resources :students, only: [:index] do
          resource :driving_course, only: [:show, :update]
        end
        resources :employees, only: [:index] do
          resource :employee_privileges, only: [:update, :show]
          resource :schedule, only: [:update, :show]
        end
        resource :employee_notifications_settings, only: [:update, :show]
        resource :schedule_settings, only: [:update, :show]
      end
    end
  end
end
