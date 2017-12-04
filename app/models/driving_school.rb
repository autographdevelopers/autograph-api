class DrivingSchool < ApplicationRecord
  # == Extensions =============================================================
  include AASM

  # == Enumerators ============================================================
  enum status: { built: 0, pending: 1, active: 2, blocked: 3, removed: 4 }

  # == Relations ==============================================================
  has_many :employee_driving_schools
  has_many :employees, through: :employee_driving_schools
  has_many :student_driving_schools
  has_many :students, through: :student_driving_schools
  has_many :schedule_boundaries
  has_one :schedule_settings_set

  # == Validations ============================================================
  validates :name, :phone_numbers, :emails, :city, :zip_code, :country, presence: true

  # == Callbacks ==============================================================
  before_create :create_verification_code

  # == State Machine ==========================================================
  aasm column: :status, enum: true do
    state :built, initial: true
    state :built, :pending, :active, :blocked, :removed

    event :confirm_registration do
      transitions from: :built, to: :pending, guard: [:has_owner?, :has_schedule_settings_set?]
    end
  end

  private

  def has_owner?
    self.employee_driving_schools.includes(:employee_privilege_set)
                                 .where(employee_privilege_set: { is_owner: true })
                                 .exists?
  end

  def has_schedule_settings_set?
    self.schedule_settings_set.present?
  end

  def create_verification_code
    self.verification_code = SecureRandom.uuid
  end
end
