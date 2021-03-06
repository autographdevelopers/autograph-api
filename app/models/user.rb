class User < ActiveRecord::Base
  extend Devise::Models

  TYPES = ['Employee', 'Student'].freeze
  EMPLOYEE = 'Employee'.freeze
  STUDENT = 'Student'.freeze

  AVATAR_VARIANTS = {
    xs: [50, 50],
    sm: [100, 100],
    md: [300, 300],
    lg: [600, 600],
  }.freeze

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

  has_many :relationships_as_subject, as: :subject, class_name: Relationship.name
  has_many :relationships_as_object, as: :object, class_name: Relationship.name

  # == Extensions =============================================================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable
         # :confirmable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :avatar

  # == Enumerators ============================================================
  enum status: { active: 0, blocked: 1, removed: 2 }

  # == Validations ============================================================
  validates :name,
            :surname,
            # :birth_date,
            :type,
            # :time_zone,
            presence: true
  # some valdiations are commented out as they made invitation flow impossible

  validate :birth_date_not_to_be_in_past

  validates :avatar,
            content_type: %w[image/png image/jpg image/jpeg],
            size: { less_than: Rails.application.secrets.avatar_size_limit_in_megabytes.megabytes }

  # == Instance Methods =======================================================
  def employee?
    is_a? Employee
  end

  def student?
    is_a? Student
  end

  def full_name
    [name, surname].reject(&:blank?).join(' ').presence
  end

  def self.build_test_user
    new(name: 'John', surname: 'Doe', email: 'test-user@test.com')
  end

  def display_name
    email
  end


  private

  #TODO find minimal required age
  def birth_date_not_to_be_in_past
    if birth_date && birth_date > Date.today
      errors.add(:birth_date, :birth_date_in_future)
    end
  end
end
