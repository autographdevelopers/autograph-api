json.results do
  json.array! @driving_lessons,
              partial: 'api/v1/driving_lessons/driving_lesson',
              as: :driving_lesson
end

json.pagination do
  json.is_more !@driving_lessons.last_page? && !@driving_lessons.out_of_range?
end
