class UserNote < ApplicationRecord
  include Discard::Model

  # == Associations =========================
  belongs_to :driving_school
  belongs_to :author, class_name: User.name
  belongs_to :user
  has_many :comments, as: :commentable
  # == Files =============================

  has_many_attached :files

  # == Validations =========================
  validates :title, presence: true
end
