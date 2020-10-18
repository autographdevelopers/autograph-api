class RenameToCourseParticipationDetailsCount < ActiveRecord::Migration[5.1]
  def change
    rename_column :courses, :course_participations_count, :course_participation_details_count
  end
end
