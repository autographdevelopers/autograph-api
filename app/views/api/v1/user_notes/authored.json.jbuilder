json.results { json.array! @notes, partial: 'api/v1/user_notes/note', as: :note }
json.pagination { json.is_more (!@notes.last_page? && !@notes.out_of_range?) }
