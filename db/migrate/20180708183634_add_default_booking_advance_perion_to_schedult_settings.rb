class AddDefaultBookingAdvancePerionToSchedultSettings < ActiveRecord::Migration[5.1]
  def change
    change_column :schedule_settings, :booking_advance_period_in_weeks, :integer, default: 10, null: false
  end
end
