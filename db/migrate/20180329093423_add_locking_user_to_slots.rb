class AddLockingUserToSlots < ActiveRecord::Migration[5.1]
  def change
    add_column :slots, :locking_user_id, :integer, index: true
    add_foreign_key :slots, :users, column: :locking_user_id
  end
end
