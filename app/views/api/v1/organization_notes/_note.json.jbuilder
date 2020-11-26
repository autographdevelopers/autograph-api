json.extract! note, :id, :title, :body, :datetime, :created_at
json.author { json.partial! 'api/v1/users/user', user: note.author }
json.files do
  json.array! note.files, partial: 'api/v1/files/file', as: :file
end
