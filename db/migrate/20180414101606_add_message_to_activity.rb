class AddMessageToActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :message, :string
  end
end
