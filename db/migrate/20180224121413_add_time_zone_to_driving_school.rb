class AddTimeZoneToDrivingSchool < ActiveRecord::Migration[5.1]
  def change
    add_column :driving_schools, :time_zone, :string
  end
end
