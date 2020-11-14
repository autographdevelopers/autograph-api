class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :body
      t.datetime :datetime
      t.references :notable, polymorphic: true, null: false, index: true
      t.references :driving_school, null: false, index: true
      t.references :user, null: false, index: true
      t.integer :context, null: false

      t.timestamps
    end
  end
end
