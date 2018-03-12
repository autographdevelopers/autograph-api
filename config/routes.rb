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
          end
        end
        resources :students, only: [:index]
        resources :employees, only: [:index] do
          resource :employee_privileges, only: [:update, :show]
          resource :schedule, only: [:update, :show]
        end
        resource :employee_notifications_settings, only: [:update, :show]
        resource :schedule_settings_set, only: [:update, :show]
        resources :schedule_boundaries, only: [:create, :index]
      end
    end
  end
end
