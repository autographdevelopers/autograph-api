class Color < ApplicationRecord
  validates :hex_val, :application, :palette_name, presence: true
  enum application: { general: 0 }
end

