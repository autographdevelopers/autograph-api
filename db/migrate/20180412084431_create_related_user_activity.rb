class CreateRelatedUserActivity < ActiveRecord::Migration[5.1]
  def change
    create_table :related_user_activities do |t|
      t.references :user, foreign_key: true
      t.references :activity, foreign_key: true
    end
  end
end
