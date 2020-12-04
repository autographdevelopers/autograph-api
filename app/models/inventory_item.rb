class InventoryItem < ApplicationRecord
  include HasPropertiesGroupsField::Model
  include Discard::Model

  belongs_to :driving_school
  belongs_to :author, class_name: User.name
  has_many :comments, as: :commentable

  has_many_attached :files

  validates :name, presence: true
end
