class InventoryItem < ApplicationRecord
  include HasPropertiesGroupsField::Model
  include Discard::Model
  acts_as_ordered_taggable

  belongs_to :driving_school
  belongs_to :author, class_name: User.name
  has_many :comments, as: :commentable

  has_many :relationships_as_subject, as: :subject, class_name: Relationship.name
  has_many :relationships_as_object, as: :object, class_name: Relationship.name

  accepts_nested_attributes_for :relationships_as_subject, allow_destroy: true
  accepts_nested_attributes_for :relationships_as_object, allow_destroy: true

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

  def display_name
    name
  end
end
