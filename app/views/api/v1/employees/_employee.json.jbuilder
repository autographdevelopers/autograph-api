json.id employee.id
json.email employee.email
json.phone_number employee.try(:phone_number)
json.name employee.name
json.surname employee.surname
json.type User::EMPLOYEE
json.status employee_driving_school.status
json.invitation_sent_at employee_driving_school.created_at
