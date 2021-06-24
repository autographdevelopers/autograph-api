json.id employee.id
json.email employee.email
json.full_name employee.full_name
json.phone_number employee.phone_number
json.name employee.name
json.surname employee.surname
json.type User::EMPLOYEE
json.status employee_driving_school.status
json.invitation_sent_at employee.invitation_sent_at

if employee&.avatar&.attached?
  json.avatar { json.partial!('api/v1/files/file', file: employee.avatar) }
else
  json.avatar nil
end
