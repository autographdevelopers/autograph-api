class CreateLabelableLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :labelable_labels do |t|
      t.references :labelable, polymorphic: true, index: true
      t.references :label, foreign_key: true, null: false

      t.timestamps
    end
  end
end
