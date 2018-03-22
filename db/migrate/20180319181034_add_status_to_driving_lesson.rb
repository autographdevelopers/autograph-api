class AddStatusToDrivingLesson < ActiveRecord::Migration[5.1]
  def change
    add_column :driving_lessons, :status, :integer, null: false
  end
end
