json.id user.id
json.email user.email
json.name user.name
json.surname user.surname
json.full_name user.full_name
json.birth_date user.birth_date
json.type user.type
json.time_zone user.time_zone

if user.avatar.attached?
  json.avatar { json.partial!('api/v1/files/file', file: user.avatar) }
else
  json.avatar nil
end
