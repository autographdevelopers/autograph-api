json.results do
  json.array! @activities do |activity|
    json.partial! 'activity', activity: activity
  end
end

json.pagination do
  json.is_more !@activities.last_page? && !@activities.out_of_range?
end

