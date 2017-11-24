json.id driving_school[:basic_information].id
json.name driving_school[:basic_information].name
json.phone_numbers driving_school[:basic_information].phone_numbers
json.emails driving_school[:basic_information].emails
json.website_link driving_school[:basic_information].website_link
json.additional_information driving_school[:basic_information].additional_information
json.city driving_school[:basic_information].city
json.street driving_school[:basic_information].street
json.country driving_school[:basic_information].country
json.profile_picture driving_school[:basic_information].profile_picture
json.driving_school_status driving_school[:basic_information].status

if @current_user.employee?
  json.employee_driving_school_status driving_school[:employee_driving_school_status]
  json.privilege_set do
    json.can_manage_employees driving_school[:employee_privilege_set].can_manage_employees
    json.can_manage_students driving_school[:employee_privilege_set].can_manage_students
    json.can_modify_schedules driving_school[:employee_privilege_set].can_modify_schedules
    json.is_driving driving_school[:employee_privilege_set].is_driving
    json.is_owner driving_school[:employee_privilege_set].is_owner
  end
end

if @current_user.student?
  json.student_driving_school_status driving_school[:student_driving_school_status]
end
