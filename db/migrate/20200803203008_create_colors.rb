class CreateColors < ActiveRecord::Migration[5.1]
  def change
    create_table :colors do |t|
      t.string :palette_name, null: false
      t.string :hex_val, null: false
      t.integer :application, null: false

      t.timestamps
    end
  end
end
