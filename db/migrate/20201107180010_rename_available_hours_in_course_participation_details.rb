class RenameAvailableHoursInCourseParticipationDetails < ActiveRecord::Migration[5.1]
  def change
    rename_column :course_participation_details, :available_hours, :available_slot_credits
  end
end
