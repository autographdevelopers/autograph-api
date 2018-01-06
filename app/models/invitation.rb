class Invitation < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :invitable, polymorphic: true

  # == Validations ============================================================
  validates :email, presence: true
end
