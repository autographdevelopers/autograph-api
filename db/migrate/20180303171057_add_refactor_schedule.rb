class AddRefactorSchedule < ActiveRecord::Migration[5.1]
  def change
    add_column :schedules, :new_template, :json, null: false, default: { monday: [], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: [], sunday: [] }
    add_column :schedules, :new_template_binding_from, :date
  end
end
