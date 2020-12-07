class InventoryItem < ApplicationRecord
  include HasPropertiesGroupsField::Model
  include Discard::Model
  acts_as_ordered_taggable

  belongs_to :driving_school
  belongs_to :author, class_name: User.name
  has_many :comments, as: :commentable

  has_many_attached :files

  validates :name, presence: true

  scope :search_term, ->(q) do
    where(%(
        inventory_items.name ILIKE :term OR
        inventory_items.description ILIKE :term
      ), term: "%#{q}%"
    )
  end
end
