json.extract! inventory_item, :id, :name, :description, :discarded_at, :created_at, :driving_school_id, :properties_groups
json.author { json.partial! 'api/v1/users/user_min', user: inventory_item.author }

json.tag_list { json.array! inventory_item.tags.pluck(:name) }
json.files { json.array! inventory_item.files, partial: 'api/v1/files/file', as: :file }
json.source_relationships { json.array! inventory_item.source_relationships, partial: 'api/v1/relationships/relationship', as: :relationship  }

# TODO: N + 1 on tags
