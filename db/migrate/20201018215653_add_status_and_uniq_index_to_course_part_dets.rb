class AddStatusAndUniqIndexToCoursePartDets < ActiveRecord::Migration[5.1]
  def change
    add_column :course_participation_details, :status, :integer, null: false, default: 0
  end
end
