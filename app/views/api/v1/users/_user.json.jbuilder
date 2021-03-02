json.id user.id
json.email user.email
json.name user.name
json.surname user.surname
json.birth_date user.birth_date
json.type user.type
json.time_zone user.time_zone

if user.avatar.attached?
  json.avatar { json.partial!('api/v1/files/file', file: user.avatar) }
else
  json.avatar nil
end

if user.id == current_user.id
  json.user_driving_schools do
    json.array! @resource.user_driving_schools.eligible_for_viewing,
                partial: 'api/v1/driving_schools/user_driving_school',
                as: :user_driving_school
  end
end
