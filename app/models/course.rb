class Course < ApplicationRecord
  has_many :course_participations
  belongs_to :driving_school
  belongs_to :type, class_name: 'Label', foreign_key: :label_id, optional: true


  enum status: { active: 0, archived: 1 }, _prefix: :status

  validates :name, :status, presence: true
  validate :type_is_a_course_category_label

  def readonly?
    course_participations.any?
  end

  private

  def type_is_a_course_category_label
    return if type.nil? || type&.purpose_course_category?

    errors.add(:base, 'Type is not a valid label marked as course_category')
  end
end
