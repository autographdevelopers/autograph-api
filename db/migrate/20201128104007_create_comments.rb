class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :author, null: false, foreign_key: { to_table: :users }, index: true
      t.references :commentable, polymorphic: true, index: true, null: false
      t.references :driving_school, foreign_key: true, index: true, null: false
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
