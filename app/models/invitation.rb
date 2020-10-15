class Invitation < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :invitable, polymorphic: true

  # == Validations ============================================================
  validates :email, :name, :surname, presence: true
  # TODO: add uniqueness in organization scope?

  def full_name
    "#{name.capitalize} #{surname.capitalize}"
  end
end
