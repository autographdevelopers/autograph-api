json.id student.id
json.email student.email
json.phone_number student.phone_number
json.name student.name
json.surname student.surname
json.type User::STUDENT
json.status student_driving_school.status
json.invitation_sent_at student.invitation_sent_at

if student.avatar.attached?
  json.avatar { json.partial!('api/v1/files/file', file: student.avatar) }
else
  json.avatar nil
end
