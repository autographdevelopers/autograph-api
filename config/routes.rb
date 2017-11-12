Rails.application.routes.draw do
  get '/', to: 'api/v1/dashboard#fo'
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/users'
      }
    end
  end
end
