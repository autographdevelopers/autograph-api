class Color < ApplicationRecord
  validates :hex_val, :application, :palette_name, presence: true
  enum application: { general: 0 }

  DEFAULT_AVATAR_PLACEHOLDER_COLOR_HEX = 'e76f51'.freeze

  def self.find_rarest_color_in(model: , school_id:, color_application:)
    joins("LEFT JOIN colorable_colors on colorable_colors.hex_val = colors.hex_val AND colorable_colors.application = #{ColorableColor.applications[color_application]}")
      .joins(
        %Q(
          LEFT JOIN #{model.table_name} ON colorable_colors.colorable_type = '#{model.name}'
            AND colorable_colors.colorable_id = #{model.table_name}.id
              AND #{model.table_name}.driving_school_id = #{school_id}
        )
      ).where("#{model.table_name}.driving_school_id = ? OR employee_driving_schools.id IS NULL", school_id)
        .group('colors.hex_val')
          .select("SUM(CASE WHEN colorable_colors.colorable_id IS NOT NULL THEN 1 ELSE 0 END) AS usages_count, colors.hex_val AS hex_val")
          .order('usages_count ASC')
          .first&.hex_val || DEFAULT_AVATAR_PLACEHOLDER_COLOR_HEX
  end
end
