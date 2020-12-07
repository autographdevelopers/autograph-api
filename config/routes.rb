Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/users',
        sessions: 'api/v1/sessions'
      }

      devise_scope :api_v1_user do
        resources :users, only: [] do
          put :update_avatar, on: :collection
          put :purge_avatar, on: :collection
        end
      end

      resources :colors, only: :index
      resources :labels
      resources :labelable_labels, only: [] do
        get :prebuilts, on: :collection
      end

      resources :driving_schools, only: [:index, :create, :update, :show, :destroy] do
        get '/:resources_name/tags' => 'tags#model_tags'

        resources :custom_activity_types, only: %i[index create update discard]

        Comment::COMMENTABLE_TYPES.each do |c|
          resources c.underscore.pluralize.to_sym, only: [] do
            resources :comments, only: %i[create index update] do
              put :discard, on: :member
            end
          end
        end
        resources :course_participation_details, only: :update do
          put :discard, on: :member
        end
        resources :course_types, only: :index
        resources :courses, only: [] do
          resources :students, only: [] do
            get :not_assigned_to_course, on: :collection
          end
        end
        resources :courses do
          put :archive, on: :member
          put :unarchive, on: :member
          resources :course_participation_details, only: :index
          resources :students, only: [] do
            resources :course_participation_details, only: :create
          end
        end
        resources :labelable_labels, only: [:index]

        resources :activities, only: [:index] do
          get :my_activities, on: :collection
        end
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

        resources :organization_notes, only: %i[create index update] do
          get :authored, on: :collection
          put :attach_file, on: :member
          put :delete_file, on: :member
          put :discard, on: :member
        end

        resources :inventory_items, only: %i[create index update] do
          put :attach_file, on: :member
          put :delete_file, on: :member
          put :discard, on: :member
        end

        resources :users, only: [] do
          resources :user_notes, only: %i[create index update] do
            get :authored, on: :collection
            put :attach_file, on: :member
            put :delete_file, on: :member
            put :discard, on: :member
          end
        end

        resources :lesson_notes, only: [] do
          get :authored, on: :collection
        end

        resources :driving_lessons, only: [:index, :create] do
          put :cancel, on: :member
          resources :lesson_notes, only: %i[create index update] do
            put :attach_file, on: :member
            put :delete_file, on: :member
            put :discard, on: :member
          end
        end
        resources :students, only: [:index] do
          resources :course_participation_details, only: [:show, :update, :index, :create]
        end
        resources :employees, only: [:index] do
          resource :employee_privileges, only: [:update, :show]
          resource :schedule, only: [:update, :show]
        end
        resources :slots, only: [:index]
        resource :employee_notifications_settings, only: [:update, :show]
        resource :schedule_settings, only: [:update, :show]

        resources :student_driving_schools,
                  only: [:show],
                  constraints: { email: /[^\/]+/ },
                  param: :email
      end

      mount ActionCable.server, at: '/cable'
    end
  end
end
