json.extract! note, :id, :title, :body, :datetime, :context, :notable_type, :notable_id, :created_at
json.author { json.partial! 'api/v1/users/user', user: note.author }
