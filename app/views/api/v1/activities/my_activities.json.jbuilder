json.array! @user_activities do |user_activity|
  json.partial! 'activity', activity: user_activity.activity
  json.read user_activity.read
end
