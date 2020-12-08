class User < ActiveRecord::Base
  TYPES = ['Employee', 'Student'].freeze
  EMPLOYEE = 'Employee'.freeze
  STUDENT = 'Student'.freeze

  # == Relations ==============================================================
  has_many :locked_slots, class_name: 'Slot', foreign_key: 'locking_user_id'
  has_many :notifiable_user_activities
  has_many :notifiable_activities,
           through: :notifiable_user_activities,
           source: :activity

  has_many :related_user_activities
  has_many :related_activities,
           through: :related_user_activities,
           source: :activity

  has_many :received_user_notes, class_name: UserNote.name, foreign_key: :user_id
  has_many :authored_user_notes, class_name: UserNote.name, foreign_key: :author_id

  # == Extensions =============================================================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # :confirmable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :avatar

  # == Enumerators ============================================================
  enum status: { active: 0, blocked: 1, removed: 2 }
  enum gender: { male: 0, female: 1 }

  # == Validations ============================================================
  validates :name, :surname, :gender, :birth_date, :type, :time_zone, presence: true
  validate :birth_date_not_to_be_in_past

  # == Instance Methods =======================================================
  def employee?
    is_a? Employee
  end

  def student?
    is_a? Student
  end

  def full_name
    "#{name.capitalize} #{surname.capitalize}"
  end

  def self.build_test_user
    new(name: 'John', surname: 'Doe', email: 'test-user@test.com')
  end

  private

  #TODO find minimal required age
  def birth_date_not_to_be_in_past
    if birth_date && birth_date > Date.today
      errors.add(:birth_date, :birth_date_in_future)
    end
  end
end
