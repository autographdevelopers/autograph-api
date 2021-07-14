class Relationship < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true

  validates :verb, presence: true

  def target_label
    target.display_name
  end
end
