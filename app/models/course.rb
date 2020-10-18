class Course < ApplicationRecord
  belongs_to :driving_school
  belongs_to :course_type

  has_many :course_participation_details

  enum status: { active: 0, archived: 1 }, _prefix: :status

  validates :name, :status, presence: true
  validates_numericality_of :course_participations_limit, only_integer: true, allow_nil: true, greater_than: 0
  validates :name, uniqueness: { scope: [:driving_school_id, :status], message: 'There already exists such course with that status' }

  def readonly?
    course_participation_details.any?
  end
end
