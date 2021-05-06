class OrganizationNote < ApplicationRecord
  include Discard::Model

  # == Associations =========================
  belongs_to :driving_school
  belongs_to :author, foreign_key: :user_id, class_name: 'User'
  has_many :comments, as: :commentable
  # == Files =============================

  has_many_attached :files

  # == Validations =========================
  validates :title, presence: true

  # == Enum =========================
  enum status: { draft: 0, published: 1 }

  scope :with_status, ->(status) {
    # byebug
    return self.kept.published if status == 'active'
    return self.discarded if status == 'archived'
    return self.draft if status == 'draft'
    return self
  }
end
