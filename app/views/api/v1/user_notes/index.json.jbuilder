json.user { json.partial! 'api/v1/users/user_min', user: @user }
json.results { json.array! @notes, partial: 'api/v1/user_notes/note', as: :note }
json.partial! 'api/v1/helper/pagination', locals: { collection: @notes }


# object -- has_many -- > relationships as target

# Relationship
  # source (polymorphic)
  # target (polymorphic)
  # verb [enum]
#
