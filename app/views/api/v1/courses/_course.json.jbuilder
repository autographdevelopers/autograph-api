json.extract! course, :id,
              :name,
              :description,
              :status,
              :start_time,
              :end_time,
              :driving_school_id,
              :course_type_id,
              :discarded_at,
              :course_participation_details_count

json.course_type { json.partial! 'api/v1/course_types/course_type', course_type: course.course_type }
