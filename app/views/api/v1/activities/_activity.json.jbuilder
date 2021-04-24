json.extract! activity,
              :id,
              :driving_school_id,
              :target_type,
              :target_id,
              :user_id,
              :activity_type,
              :message,
              :note,
              :date,
              :created_at

json.user { json.partial! 'api/v1/users/user_min', user: activity.user }
