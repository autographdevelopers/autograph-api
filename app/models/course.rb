class Course < ApplicationRecord
  include Discard::Model

  belongs_to :driving_school
  belongs_to :course_type

  has_many :course_participation_details

  has_many :source_relationships, as: :source, class_name: Relationship.name
  has_many :target_relationships, as: :target, class_name: Relationship.name

  enum status: { default: 0 }, _prefix: :status

  validates :name, :status, :course_type_id, presence: true
  validates_numericality_of :course_participations_limit, only_integer: true, allow_nil: true, greater_than: 0
  validates :name, uniqueness: { scope: [:driving_school_id, :status, :discarded_at], message: 'There already exists such course with that status' }

  scope :search, ->(q) do
    where(%(
        courses.name ILIKE :term
        OR courses.description ILIKE :term
      ), term: "%#{q}%"
    )
  end

  def display_name
    name
  end
end
