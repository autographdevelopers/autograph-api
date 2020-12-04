class CreateInventoryItems < ActiveRecord::Migration[5.2]
  def change
    create_table :inventory_items do |t|
      t.string :name, null: false
      t.text :description
      t.jsonb :properties_groups, default: []
      t.references :driving_school, foreign_key: true, index: true, null: false
      t.references :author, null: false, foreign_key: { to_table: :users }, index: true
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
