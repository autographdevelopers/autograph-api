class AddSlotsCounter < ActiveRecord::Migration[5.1]
  def change
    add_column :course_participation_details, :booked_slots_count, :integer, null: false, default: 0
    add_column :course_participation_details, :used_slots_count, :integer, null: false, default: 0
  end
end
