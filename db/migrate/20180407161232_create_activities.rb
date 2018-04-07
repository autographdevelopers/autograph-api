class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.references :driving_school, foreign_key: true
      t.references :target, polymorphic: true, index: true
      t.references :user, foreign_key: true
      t.integer :activity_type

      t.timestamps
    end
  end
end
