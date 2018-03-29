class ApplicationJob < ActiveJob::Base
  def build_channel_string(employee_driving_school_id)
    "slots_#{employee_driving_school_id}"
  end
end
