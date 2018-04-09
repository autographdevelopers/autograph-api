class UserActivity < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :activity
  belongs_to :user

  # == Validations ============================================================
  validates :activity, uniqueness: { scope: :user }
end
