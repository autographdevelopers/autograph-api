class AddCreatedAutomaticallyToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :created_automatically, :boolean, null: false, default: false
  end
end
