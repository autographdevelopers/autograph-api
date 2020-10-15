json.results { json.array! @courses, partial: 'courses/course', as: :course }
json.pagination { json.is_more !@courses.last_page? }
