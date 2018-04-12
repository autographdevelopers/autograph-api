json.array! @notifiable_user_activities do |notifiable_user_activity|
  json.partial! 'activity', activity: notifiable_user_activity.activity
  json.read notifiable_user_activity.read
end
