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
        end
        resources :invitations, only: [:create]
        resources :students, only: [:index]
        resources :employees, only: [:index]
        resource :employee_notifications_settings_set, only: [:update]
        resource :schedule_settings_set, only: [:update]
        resources :schedule_boundaries, only: [:create]
      end
    end
  end
end
