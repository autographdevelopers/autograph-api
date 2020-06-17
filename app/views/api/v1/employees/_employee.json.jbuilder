json.id employee&.id
json.email employee&.email || invitation&.email
json.invitation_id invitation&.id
json.virtual_id "#{item.model_name.name.parameterize}-#{item.id}"
json.phone_number employee.try(:phone_number)
json.name item.name
json.surname item.surname
json.type User::EMPLOYEE
json.status employee_driving_school.status
json.invitation_sent_at employee_driving_school.created_at
