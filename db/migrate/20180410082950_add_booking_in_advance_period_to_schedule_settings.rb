class AddBookingInAdvancePeriodToScheduleSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :schedule_settings, :booking_advance_period_in_weeks, :integer, default: 0, null: false
  end
end
