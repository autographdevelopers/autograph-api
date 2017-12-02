class CreateScheduleBoundaries < ActiveRecord::Migration[5.1]
  def change
    create_table :schedule_boundaries do |t|
      t.integer :weekday,           null: false
      t.datetime :start_time,       null: false
      t.datetime :end_time,         null: false
      t.references :driving_school, null: false

      t.timestamps
    end
  end
end
