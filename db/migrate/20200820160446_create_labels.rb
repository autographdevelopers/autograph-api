class CreateLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :labels do |t|
      t.string :name, null: false
      t.text :description
      t.integer :purpose, null: false
      t.boolean :prebuilt, null: false, default: false

      t.timestamps
    end
  end
end
