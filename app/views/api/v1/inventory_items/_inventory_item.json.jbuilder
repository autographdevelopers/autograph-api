json.extract! inventory_item, :id, :name, :description, :discarded_at, :created_at, :driving_school_id, :properties_groups
json.author { json.partial! 'api/v1/users/user_min', user: inventory_item.author }

json.tag_list { json.array! inventory_item.tags.pluck(:name) }
json.files { json.array! inventory_item.files, partial: 'api/v1/files/file', as: :file }
json.relationships_as_subject { json.array! inventory_item.relationships_as_subject, partial: 'api/v1/relationships/relationship', as: :relationship}
json.relationships_as_object { json.array! inventory_item.relationships_as_object, partial: 'api/v1/relationships/relationship', as: :relationship }
