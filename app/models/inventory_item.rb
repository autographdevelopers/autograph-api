class InventoryItem < ApplicationRecord
  include HasPropertiesGroupsField::Model
  include Discard::Model
  acts_as_ordered_taggable

  belongs_to :driving_school
  belongs_to :author, class_name: User.name
  has_many :comments, as: :commentable

  has_many_attached :files

  validates :name, presence: true

  ACTIVITY_PUBLIC_ATTRS = [:name]

  scope :search_term, ->(q) do
    where(%(
        inventory_items.name ILIKE :term OR
        inventory_items.description ILIKE :term
      ), term: "%#{q}%"
    )
  end

  def message_merge_params
    attributes.symbolize_keys.slice(*ACTIVITY_PUBLIC_ATTRS)
  end

  def self.build_test_target
    new(name: 'Test Item')
  end
end
