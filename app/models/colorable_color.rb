class ColorableColor < ApplicationRecord
  belongs_to :colorable, polymorphic: true
  validates :hex_val, :application, presence: true

  enum application: { avatar_placeholder: 0, school_app_primary_ui_theme: 1 }

  COLORABLE_TYPES = [EmployeeDrivingSchool.name, StudentDrivingSchool.name, DrivingSchool.name, User.name]

  validates :colorable_type, inclusion: { in: COLORABLE_TYPES }, if: :colorable
  validates :hex_val, uniqueness: { scope: %i[colorable_type colorable_id application] }
end
