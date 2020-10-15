json.extract! course, :id,
              :name,
              :description,
              :status,
              :start_time,
              :end_time,
              :driving_school_id

json.type course.type do |label|
  json.partial! 'api/v1/labels/label', label: label
end