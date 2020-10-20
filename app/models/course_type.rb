class CourseType < ApplicationRecord
  include Discard::Model

  belongs_to :driving_school, optional: true
  has_many :courses

  enum status: { default: 0 }, _prefix: :status

  validates :name, presence: true, uniqueness: { scope: [:driving_school_id, :status, :discarded_at] }
  validates :status, presence: true

  scope :only_prebuilts, -> { where(driving_school_id: nil) }
  scope :reject_names, ->(rejection_list) { where.not(name: rejection_list) }

  after_create_commit -> { Courses::CreateDefaultCourseJob.perform_later(driving_school_id, id, name) }, if: :driving_school_id
end
