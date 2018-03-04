class AddCountryCodeToDrivingSchool < ActiveRecord::Migration[5.1]
  def change
    add_column :driving_schools, :country_code, :string, null: false
  end
end
