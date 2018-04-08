class Activities::CreateService
  def initialize(current_user, target, activity_type)

  end

  def call
    Activity.create()
  end
end
