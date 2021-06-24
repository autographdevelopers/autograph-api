json.extract! inventory_item, :id, :name, :description, :discarded_at, :created_at, :driving_school_id, :properties_groups, :tag_list
json.author { json.partial! 'api/v1/users/user_min', user: inventory_item.author }
json.files { json.array! inventory_item.files, partial: 'api/v1/files/file', as: :file }
# TODO: N + 1 on tags
