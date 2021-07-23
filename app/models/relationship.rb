class Relationship < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :object, polymorphic: true

  validates :verb, presence: true

  enum voice: { active: 'active', passive: 'passive' }

  def object_label
    object.display_name
  end

  def subject_label
    subject.display_name
  end
end
