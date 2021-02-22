class UserNote < ApplicationRecord
  include Discard::Model

  # == Associations =========================
  belongs_to :driving_school
  belongs_to :author, class_name: User.name
  belongs_to :user
  has_many :comments, as: :commentable
  # == Files =============================

  has_many_attached :files
  # validates :files, limit: { min: 0, max: 3 } # does not work ;C works only on AR save / update

  # == Validations =========================
  validates :title, presence: true

  # == Enum =========================
  enum status: { draft: 0, published: 1 }
end
