class DrivingSchool < ApplicationRecord
  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, blocked: 2, removed: 3 }

  # == Relations ==============================================================
  has_many :employee_driving_schools
  has_many :employees, through: :employee_driving_schools
  has_many :student_driving_schools
  has_many :students, through: :student_driving_schools
  has_many :schedule_boundaries
  has_one :schedule_setting

  # == Validations ============================================================
  validates :name, :phone_numbers, :emails, :city, :zip_code, :country, presence: true

  # == Callbacks ==============================================================
  before_create :create_verification_code

  private

  def create_verification_code
    self.verification_code = SecureRandom.uuid
  end
end
