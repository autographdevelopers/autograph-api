class RenameUserActivityToNotifiableUserActivity < ActiveRecord::Migration[5.1]
  def change
    rename_table :user_activities, :notifiable_user_activities
  end
end
