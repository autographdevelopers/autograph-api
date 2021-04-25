json.results { json.array! @notes, partial: 'api/v1/organization_notes/note', as: :note }

json.partial! 'api/v1/helper/pagination', locals: { collection: @notes }
