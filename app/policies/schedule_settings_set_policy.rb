class ScheduleSettingsSetPolicy < ApplicationPolicy
  allow :update?, if: -> { owner_of_driving_school?(record.driving_school.id) }
end
