json.results { json.array! @course_types, partial: 'api/v1/course_types/course_type', as: :course_type }
json.pagination { json.is_more (!@course_types.last_page? && !@course_types.out_of_range?) }
