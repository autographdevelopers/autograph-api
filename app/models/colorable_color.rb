class ColorableColor < ApplicationRecord
  belongs_to :colorable, polymorphic: true
  validates :hex_val, :application, presence: true

  enum application: { avatar_placeholder: 0, school_app_primary_ui_theme: 1 }

end
