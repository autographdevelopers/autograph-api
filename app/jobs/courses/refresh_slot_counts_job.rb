class Courses::RefreshSlotCountsJob < ApplicationJob
  queue_as :default

  def perform(course_participation_detail_id)
    CourseParticipationDetail.find(course_participation_detail_id).refresh_slot_counts!
  end
end
