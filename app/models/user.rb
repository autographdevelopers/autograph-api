class User < ActiveRecord::Base
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

  private

  #TODO find minimal required age
  def birth_date_not_to_be_in_past
    if birth_date && birth_date > Date.today
      errors.add(:birth_date, :birth_date_in_future)
    end
  end
end
