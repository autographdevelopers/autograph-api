json.extract! inventory_item, :id, :name, :description, :discarded_at, :created_at, :driving_school_id, :properties_groups
json.author { json.partial! 'api/v1/users/user', user: inventory_item.author }
json.files { json.array! inventory_item.files, partial: 'api/v1/files/file', as: :file }
