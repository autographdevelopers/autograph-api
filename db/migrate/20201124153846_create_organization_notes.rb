class CreateOrganizationNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :organization_notes do |t|
      t.string :title, null: false
      t.text :body
      t.datetime :datetime
      t.references :driving_school, null: false, index: true
      t.references :user, null: false, index: true
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
