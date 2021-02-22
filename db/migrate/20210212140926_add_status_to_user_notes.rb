class AddStatusToUserNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :user_notes, :status, :integer, default: 0, index: true
  end
end
