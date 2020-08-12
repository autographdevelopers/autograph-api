class CreateColorableColors < ActiveRecord::Migration[5.1]
  def change
    create_table :colorable_colors do |t|
      t.references :colorable, polymorphic: true, index: true
      t.string :hex_val, null: false
      t.integer :application, null: false

      t.timestamps
    end
  end
end
