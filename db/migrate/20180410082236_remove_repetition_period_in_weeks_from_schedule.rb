class RemoveRepetitionPeriodInWeeksFromSchedule < ActiveRecord::Migration[5.1]
  def change
    remove_column :schedules, :repetition_period_in_weeks, :integer, default: 0, null: false
  end
end
