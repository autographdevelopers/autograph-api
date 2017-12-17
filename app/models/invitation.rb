class Invitation < ApplicationRecord
  belongs_to :invitable, polymorphic: true

  validates :email, presence: true
end
