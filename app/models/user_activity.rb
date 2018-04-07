class UserActivity < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :activity
  belongs_to :user
end
