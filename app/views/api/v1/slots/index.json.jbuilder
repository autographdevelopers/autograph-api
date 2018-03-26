json.array! @slots do |slot|
  json.partial! 'slot', slot: slot
  json.employee_id slot.employee_driving_school.employee_id
end
