class DrivingSchool < ApplicationRecord
  # == Enumerators ============================================================
  enum status: { built: 0, pending: 1, active: 2, blocked: 3, removed: 4 }

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
