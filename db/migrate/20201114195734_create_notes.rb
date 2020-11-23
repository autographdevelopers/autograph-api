class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :body
      t.datetime :datetime
      t.references :driving_lesson, null: false, index: true
      t.references :driving_school, null: false, index: true
      t.references :user, null: false, index: true
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
