class AddUniqIndexToCourses < ActiveRecord::Migration[5.1]
  def change
    add_index :courses, [:name, :driving_school_id, :status], unique: true
  end
end
