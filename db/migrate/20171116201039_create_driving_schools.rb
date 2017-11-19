class CreateDrivingSchools < ActiveRecord::Migration[5.1]
  def change
    create_table :driving_schools do |t|
      t.string :name,                   null: false
      t.string :phone_numbers,          array: true, default: [], null: false
      t.string :emails,                 array: true, default: [], null: false
      t.string :website_link
      t.text :additional_information
      t.string :city,                   null: false
      t.string :zip_code,               null: false
      t.string :street,                 null: false
      t.string :country,                null: false
      t.integer :status,                null: false, default: 0
      t.string :profile_picture
      t.string :verification_code,      null: false
      t.decimal :latitude,              precision: 9, scale: 6
      t.decimal :longitude,             precision: 9, scale: 6

      t.timestamps
    end

    add_index :driving_schools, :name
  end
end
