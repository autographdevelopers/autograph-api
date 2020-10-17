class Course < ApplicationRecord
  belongs_to :driving_school
  belongs_to :course_type

  has_many :course_participations

  enum status: { active: 0, archived: 1 }, _prefix: :status

  validates :name, :status, presence: true

  def readonly?
    course_participations.any?
  end
end
