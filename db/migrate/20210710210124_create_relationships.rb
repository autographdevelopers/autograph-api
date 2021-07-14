class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships, id: :uuid do |t|
      t.references :source, polymorphic: true, index: true, null: false
      t.references :target, polymorphic: true, index: true, null: false
      t.string :verb, null: false

      t.timestamps
    end
  end
end
