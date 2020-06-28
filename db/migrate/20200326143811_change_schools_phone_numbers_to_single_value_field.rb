class ChangeSchoolsPhoneNumbersToSingleValueField < ActiveRecord::Migration[5.1]
  def change
    remove_column :driving_schools, :phone_numbers
    add_column :driving_schools, :phone_number, :string
  end
end
