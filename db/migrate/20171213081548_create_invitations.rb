class CreateInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :invitations do |t|
      t.string :email, null: false
      t.string :name
      t.string :surname
      t.references :invitable, polymorphic: true

      t.timestamps
    end
  end
end
