class ChangeSchoolsEmailToSingleValueField < ActiveRecord::Migration[5.1]
  def change
    remove_column :driving_schools, :emails
    add_column :driving_schools, :email, :string
  end
end
