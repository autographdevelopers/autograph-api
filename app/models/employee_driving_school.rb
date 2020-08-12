class EmployeeDrivingSchool < ApplicationRecord
  include AASM

  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2, rejected: 3 }

  # == Relations ==============================================================
  belongs_to :employee, optional: true
  belongs_to :driving_school
  has_one :employee_privileges
  has_one :employee_notifications_settings
  has_one :invitation, as: :invitable
  has_one :schedule
  has_one :avatar_placeholder_color,
                -> { avatar_placeholder },
                as: :colorable,
                class_name: 'ColorableColor'.freeze


  has_many :slots

  # == Scopes =================================================================
  scope :active_with_active_driving_school, -> {
    where(status: :active, driving_schools: { status: :active })
        .includes(:driving_school)
  }

  scope :pending_with_active_driving_school, -> {
    where(status: :pending, driving_schools: { status: :active })
        .includes(:driving_school)
  }

  scope :archived_with_active_driving_school, -> {
    where(status: :archived, driving_schools: { status: :active })
        .includes(:driving_school)
  }

  scope :searchTerm, ->(q) do
    where(%(
        users.name ILIKE :term
        OR users.surname ILIKE :term
        OR users.email ILIKE :term
        OR invitations.email ILIKE :term
        OR invitations.name ILIKE :term
        OR invitations.surname ILIKE :term
      ), term: "%#{q}%"
    )
  end

  scope :eligible_for_viewing, -> {
    where(status: [:active, :pending])
      .includes(:driving_school, :employee_privileges)
  }

  scope :employee_ids, ->(ids) do
    where(employee_id: ids)
  end

  # == Validations ============================================================
  validates :status, presence: true

  # == Callbacks ==============================================================
  after_create :create_schedule

  # == State Machine ==========================================================
  aasm column: :status, enum: true do
    state :pending, initial: true
    state :pending, :active, :archived, :rejected

    event :activate do
      transitions from: :pending, to: :active
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :archive do
      transitions to: :archived
    end
  end

  def employee_full_name
    employee&.full_name || invitation.full_name
  end

  def employee_email
    employee&.email || invitation.email
  end
end

# # Find least popular avatar color
# Color
#   .joins('LEFT JOIN colorable_colors on colorable_colors.hex_val = colors.hex_val')
#   .joins("LEFT JOIN employee_driving_schools ON colorable_colors.colorable_type = 'EmployeeDrivingSchool'")
#   .where('employee_driving_schools.driving_school_id = ? OR employee_driving_schools.id IS NULL', 61)
#   .group('colors.hex_val')
#   .select("SUM(CASE WHEN colorable_colors.colorable_id IS NOT NULL THEN 1 ELSE 0 END) AS usages_count, colors.hex_val")
#   .order('usages_count ASC')
#   .limit(1)
#
# # Alternative:
#
# EmployeeDrivingSchool
#   .where('driving_school_id = ? OR driving_school_id IS NULL', 61)
#   .joins("LEFT JOIN colorable_colors ON colorable_colors.colorable_type = 'EmployeeDrivingSchool' AND colorable_colors.colorable_id = employee_driving_schools.id AND colorable_colors.application = 0")
#   .joins('RIGHT JOIN colors ON colors.hex_val = colorable_colors.hex_val')
#   .group('colors.hex_val')
#   .select("SUM(CASE WHEN colorable_colors.colorable_id IS NOT NULL THEN 1 ELSE 0 END) AS usages_count, colors.hex_val")
#   .order('usages_count ASC')
#   .limit(1)
#
# # Variables in query:
# # - class ( EmployeeDrivingSchool )
# # - driving_school_id
# # - colorable_colors.application ?