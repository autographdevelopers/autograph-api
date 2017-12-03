Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/users',
        sessions: 'api/v1/sessions'
      }

      resources :driving_schools, only: [:index, :create] do
        resource :employee_notifications_settings_set, only: [:update]
        resource :schedule_setting, only: [:update]
        resources :schedule_boundaries, only: [:create]
      end
    end
  end
end
