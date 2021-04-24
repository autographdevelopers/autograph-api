json.results do
  json.array! @notifiable_user_activities do |notifiable_user_activity|
    json.partial! 'activity', activity: notifiable_user_activity.activity
    json.read notifiable_user_activity.read
  end
end

json.partial! 'api/v1/helper/pagination', locals: { collection: @notifiable_user_activities }
