class CourseType < ApplicationRecord
  belongs_to :driving_school, optional: true
  has_many :courses

  enum status: { active: 0, archived: 1 }, _prefix: :status

  validates :name, presence: true, uniqueness: { scope: [:driving_school_id, :status] }
  validates :status, presence: true

  scope :only_prebuilts, -> { where(driving_school_id: nil) }
  scope :reject_names, ->(rejection_list) { where.not(name: rejection_list) }
end
