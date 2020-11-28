class UserOrganizationNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_notes do |t|
      t.string :title, null: false
      t.text :body
      t.datetime :datetime
      t.references :author, null: false, foreign_key: { to_table: :users }, index: true
      t.references :user, null: false, index: true
      t.references :driving_school, null: false, index: true
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
