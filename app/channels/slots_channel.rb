class SlotsChannel < ApplicationCable::Channel
  def subscribed
    @driving_school_id = params[:driving_school_id]
    @employee_id = params[:employee_id]

    @employee_driving_school = set_employee_driving_school(
      @driving_school_id, @employee_id
    )

    if @employee_driving_school.present?
      stream_from build_channel_string(@employee_driving_school.id)
    else
      reject
    end
  end

  def unsubscribed
    Slot.available.future.locked.where(
      locking_user_id: current_user.id,
      employee_driving_school_id: @employee_driving_school.id,
    )&.find_each(&:unlock_during_booking)
  end

  def lock_slot(data)
    Slot.available.future.unlocked.find_by_id(data['slot_id'])
                                  &.lock_during_booking(current_user)
  end

  def unlock_slot(data)
    Slot.available.future.locked.find_by(
      id: data['slot_id'], locking_user_id: current_user.id
    )&.unlock_during_booking
  end

  private

  def build_channel_string(employee_driving_school_id)
    "slots_#{employee_driving_school_id}"
  end

  def set_employee_driving_school(driving_school_id, employee_id)
    driving_school = current_user.user_driving_schools
                                 .active_with_active_driving_school
                                 .find_by(driving_school_id: driving_school_id)
                                 .driving_school

    return unless driving_school.present?

    driving_school.employee_driving_schools
                  .active
                  .find_by(employee_id: employee_id)
  end
end
