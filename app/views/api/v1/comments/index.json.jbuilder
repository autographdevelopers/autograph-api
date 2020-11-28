json.results do
  json.array! @comments,
              partial: 'api/v1/comments/comment',
              as: :comment
end

json.pagination { json.is_more (!@comments.last_page? && !@comments.out_of_range?) }
