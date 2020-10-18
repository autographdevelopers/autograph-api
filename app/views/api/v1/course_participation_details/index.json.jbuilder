json.results do
  json.array! @course_participation_details,
              partial: 'api/v1/course_participation_details/course_participation_detail',
              as: :course_participation_detail
end

json.pagination { json.is_more (!@course_participation_details.last_page? && !@course_participation_details.out_of_range?) }
