class User < ActiveRecord::Base
  TYPES = ['Employee', 'Student'].freeze

  # == Extensions =============================================================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  include DeviseTokenAuth::Concerns::User

  # == Enumerators ============================================================
  enum status: { active: 0, blocked: 1, removed: 2 }
  enum gender: { male: 0, female: 1 }

  # == Validations ============================================================
  validates :name, :surname, :gender, :birth_date, :type, :time_zone, presence: true
  validate :birth_date_not_to_be_in_past

  # == Instance Methods =======================================================
  def employee?
    self.is_a? Employee
  end

  def student?
    self.is_a? Student
  end

  def get_relation(driving_school_id)
    if self.employee?
      self.employee_driving_schools.find_by!(driving_school_id: driving_school_id)
    elsif self.student?
      self.student_driving_schools.find_by!(driving_school_id: driving_school_id)
    end
  end

  private

  #TODO find minimal required age
  def birth_date_not_to_be_in_past
    if birth_date && birth_date > Date.today
      errors.add(:birth_date, :birth_date_in_future)
    end
  end
end
