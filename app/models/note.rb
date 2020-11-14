class Note < ApplicationRecord
  # == Associations =========================
  belongs_to :notable, polymorphic: true, required: true
  belongs_to :driving_school
  belongs_to :author, foreign_key: :user_id, class_name: 'User'

  # == Enums =============================
  enum context: { lesson_note_from_instructor: 0, personal_note: 1 }

  # == Constants =========================
  NOTABLE_TYPES = [DrivingLesson.name, User.name]
  NOTABLE_CONTEXTS_WHITELIST = {
    DrivingLesson.name => 'lesson_note_from_instructor',
    User.name => 'personal_note'
  }

  # == Validations =========================
  validates :title, :context, presence: true
  validates :notable_type, inclusion: { in: NOTABLE_TYPES }, if: :notable
  validates :context,
            inclusion: { in: proc { |record| NOTABLE_CONTEXTS_WHITELIST[record.notable_type] || [] } },
            if: -> { context && notable }
end
