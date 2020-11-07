class AddSchoolRefToParicipationsTable < ActiveRecord::Migration[5.1]
  def up
    add_reference :course_participation_details, :driving_school, null: false, index: true, foreign_key: true
  end

  def down
    remove_reference :course_participation_details, :driving_school, null: false, index: true, foreign_key: true
  end
end
