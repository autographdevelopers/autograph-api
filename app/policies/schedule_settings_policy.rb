class ScheduleSettingsPolicy < ApplicationPolicy
  allow :update?, :show?, if: -> { owner_of_driving_school?(record.driving_school.id) }
end
