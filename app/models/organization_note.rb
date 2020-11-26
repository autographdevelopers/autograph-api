class OrganizationNote < ApplicationRecord
  include Discard::Model

  # == Associations =========================
  belongs_to :driving_school
  belongs_to :author, foreign_key: :user_id, class_name: 'User'

  # == Files =============================

  has_many_attached :files

  # == Validations =========================
  validates :title, presence: true
end
