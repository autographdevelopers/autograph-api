class Courses::CreateDefaultCourseJob < ApplicationJob
  queue_as :default

  def perform(driving_school_id, course_type_id, name)
    Course.create!(
      driving_school_id: driving_school_id,
      course_type_id: course_type_id,
      name: name,
      created_automatically: true,
    )
  end
end
