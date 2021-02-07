class DropSomeNullConstraintsFromUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:users, :name, true)
    change_column_null(:users, :surname, true)
    change_column_null(:users, :gender, true)
    change_column_null(:users, :birth_date, true)
    change_column_null(:users, :time_zone, true)
  end
end
