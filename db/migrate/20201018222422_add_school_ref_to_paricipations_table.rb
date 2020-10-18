class AddSchoolRefToParicipationsTable < ActiveRecord::Migration[5.1]
  def change
    add_reference :course_participation_details, :driving_school, null: false, index: true
  end
end
