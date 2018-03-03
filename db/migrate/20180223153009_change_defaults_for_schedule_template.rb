class ChangeDefaultsForScheduleTemplate < ActiveRecord::Migration[5.1]
  def up
    change_column_default :schedules, :current_template, { monday: [], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: [], sunday: [] }
  end

  def down
    change_column_default :schedules, :current_template, {}
  end
end
