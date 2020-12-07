class CreateCustomActivityTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_activity_types do |t|
      t.string :name, null: false
      t.string :message_template, null: false
      t.string :target_type
      t.integer :notification_receivers, null: false, default: 0
      t.references :driving_school, null: false, index: true

      t.integer :datetime_input_config, default: 0
      t.string :datetime_input_instructions

      t.integer :text_note_input_config, default: 0
      t.string :text_note_input_instructions
      t.timestamps
    end
  end
end
