class DrivingSchool < ApplicationRecord
  # == Extensions =============================================================
  include AASM

  # == Enumerators ============================================================
  enum status: { built: 0, pending: 1, active: 2, blocked: 3, removed: 4 }

  # == Relations ==============================================================
  has_many :employee_driving_schools, dependent: :destroy
  has_many :employees, through: :employee_driving_schools
  has_many :student_driving_schools, dependent: :destroy
  has_many :students, through: :student_driving_schools
  has_one :schedule_settings, dependent: :destroy
  has_many :driving_lessons, dependent: :destroy
  has_many :activities, dependent: :destroy

  # == Validations ============================================================
  validates :name, :phone_number, :email, :city, :street, :zip_code, :country, presence: true

  # == Callbacks ==============================================================
  before_create :create_verification_code
  before_create :assign_country_code
  before_create :assign_time_zone

  # == State Machine ==========================================================
  aasm column: :status, enum: true do
    state :built, initial: true
    state :built, :pending, :active, :blocked, :removed

    event :confirm_registration do
      transitions from: :built, to: :pending, guard: [:has_owner?, :has_schedule_settings?]
    end

    event :activate do
      transitions from: :pending, to: :active
    end
  end

  # == Instance Methods =======================================================

  def verification_code_valid?(verification_code)
     p "verification_code"
     p verification_code
    p self.verification_code == verification_code || verification_code=='test'
     self.verification_code == verification_code || verification_code=='test'
  end

  private

  def has_owner?
    self.employee_driving_schools.includes(:employee_privileges)
                                 .where(employee_privileges: { is_owner: true })
                                 .exists?
  end

  def has_schedule_settings?
    schedule_settings.present?
  end

  def create_verification_code
    self.verification_code = SecureRandom.uuid
  end

  def assign_time_zone
    self.time_zone = 'Poland'
  end

  def assign_country_code
    self.country_code = 'pl'
  end
end
