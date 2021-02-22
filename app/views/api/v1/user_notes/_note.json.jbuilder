json.extract! note, :id, :title, :body, :datetime, :created_at, :author_id, :user_id, :status
json.author { json.partial! 'api/v1/users/user', user: note.author }
json.user { json.partial! 'api/v1/users/user', user: note.user }
json.files do
  json.array! note.files, partial: 'api/v1/files/file', as: :file
end
