class DeleteScheduleBoundaries < ActiveRecord::Migration[5.1]
  def change
    drop_table :schedule_boundaries
  end
end
