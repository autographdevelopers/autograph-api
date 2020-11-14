class AddUniqIndexToColorableColor < ActiveRecord::Migration[5.1]
  def change
    add_index :colorable_colors, [:hex_val, :colorable_type, :colorable_id, :application], unique: true, name: 'index_col_col_hex_appl_uniq'
  end
end
