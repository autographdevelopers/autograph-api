class Comment < ApplicationRecord
  include Discard::Model

  belongs_to :driving_school
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true

  COMMENTABLE_TYPES = [UserNote.name, OrganizationNote.name, LessonNote.name].freeze
  validates :commentable_type, inclusion: { in: COMMENTABLE_TYPES }
  validates :body, presence: true
end