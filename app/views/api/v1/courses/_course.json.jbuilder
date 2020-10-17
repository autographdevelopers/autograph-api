json.extract! course, :id,
              :name,
              :description,
              :status,
              :start_time,
              :end_time,
              :driving_school_id

json.course_type { json.partial! 'api/v1/course_types/course_type', course_type: course.course_type }
