json.results do
  json.array! @notifiable_user_activities do |notifiable_user_activity|
    json.partial! 'activity', activity: notifiable_user_activity.activity
    json.read notifiable_user_activity.read
  end
end

json.pagination do
  json.is_more !@notifiable_user_activities.last_page? && !@notifiable_user_activities.out_of_range?
end

