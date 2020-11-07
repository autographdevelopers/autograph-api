class ChangeColTypeAvailableSlotCredits < ActiveRecord::Migration[5.1]
  def change
    remove_column :course_participation_details, :available_slot_credits
    add_column :course_participation_details, :available_slot_credits, :integer, null: false, default: 0
  end
end
