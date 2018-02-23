class RenameFieldsInSchedule < ActiveRecord::Migration[5.1]
  def change
    rename_column :schedules, :slots_template, :template
  end
end
