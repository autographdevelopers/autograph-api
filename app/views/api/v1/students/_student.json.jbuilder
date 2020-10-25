json.id student&.id
json.email student&.email || invitation&.email
json.invitation_id invitation&.id
json.virtual_id "#{item.model_name.name.parameterize}-#{item.id}"
json.phone_number student.try(:phone_number)
json.name item.name
json.surname item.surname
json.type User::STUDENT
json.status student_driving_school.status
json.invitation_sent_at student_driving_school.created_at
json.avatar_placeholder_color student_driving_school.avatar_placeholder_color&.hex_val Color::DEFAULT_AVATAR_PLACEHOLDER_COLOR_HEX