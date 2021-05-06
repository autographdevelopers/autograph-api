json.extract! comment, :id, :body, :created_at, :driving_school_id, :commentable_type, :commentable_id, :discarded_at
json.author { json.partial! 'api/v1/users/user_min', user: comment.author }
