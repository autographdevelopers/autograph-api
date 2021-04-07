json.results { json.array! @courses, partial: 'api/v1/courses/course', as: :course }
json.partial! 'api/v1/helper/pagination', locals: { collection: @courses }
