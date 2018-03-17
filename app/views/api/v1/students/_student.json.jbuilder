json.id student.id
json.email student.email
json.phone_number student.try(:phone_number)
json.name student.name
json.surname student.surname
json.type User::STUDENT
json.status student_driving_school.status
json.invitation_sent_at student_driving_school.created_at
