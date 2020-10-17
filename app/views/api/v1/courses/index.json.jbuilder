json.results { json.array! @courses, partial: 'api/v1/courses/course', as: :course }
json.pagination { json.is_more (!@courses.last_page? && !@courses.out_of_range?) } # TODO fix other paginaitons info that way
