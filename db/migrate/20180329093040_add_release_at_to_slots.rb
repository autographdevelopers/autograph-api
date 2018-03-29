class AddReleaseAtToSlots < ActiveRecord::Migration[5.1]
  def change
    add_column :slots, :release_at, :datetime
  end
end
