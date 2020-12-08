class Activity < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :driving_school
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :custom_activity_type, optional: true
  belongs_to :user
  has_many :notifiable_user_activities
  has_many :notifiable_users,
           through: :notifiable_user_activities,
           source: :user

  has_many :related_user_activities
  has_many :related_users,
           through: :related_user_activities,
           source: :user

  # == Enumerators ============================================================
  enum activity_type: {
    student_invitation_sent: 0,
    student_invitation_withdrawn: 1,
    student_invitation_accepted: 2,
    student_invitation_rejected: 3,
    employee_invitation_sent: 4,
    employee_invitation_withdrawn: 5,
    employee_invitation_accepted: 6,
    employee_invitation_rejected: 7,
    driving_course_changed: 8,
    schedule_changed: 9,
    driving_lesson_canceled: 10,
    driving_lesson_scheduled: 11
  }

  # == Validations ============================================================
  validates :message, presence: true
  validates :note, presence: true, if: -> { custom_activity_type&.text_note_input_required? }
  validates :date, presence: true, if: -> { custom_activity_type&.datetime_input_required? }

  validate :activity_type_xor_custom_activity_type

  # == Scopes =================================================================
  scope :related_to_user, ->(value) do
    includes(:related_user_activities).where(related_user_activities: { user_id: value })
  end

  # == Callbacks ==============================================================
  before_validation :determine_message, on: :create
  after_commit :notify_about_activity, on: :create

  def determine_message_from_custom_type!
    p "======================="
    p "======================="
    p "======================="
    p "======================="

    locale_keys_to_code_keys = I18n.t('activities.custom_messages.current_user')
    p "locale_keys_to_code_keys"
    p locale_keys_to_code_keys
    code_keys_to_corresponding_values = { user_full_name: user.full_name }


    if target
      targets_locale_key_to_code_key = I18n.t("activities.custom_messages.#{target.class.name.underscore}")
      locale_keys_to_code_keys = locale_keys_to_code_keys.merge(targets_locale_key_to_code_key)
      p "locale_keys_to_code_keys"
      p locale_keys_to_code_keys
      code_keys_to_corresponding_values = target.message_merge_params.merge(code_keys_to_corresponding_values)
    end

    p locale_keys_to_code_keys
    p "locale_keys_to_code_keys"
    locale_keys_to_code_keys = locale_keys_to_code_keys.transform_values { |v| "%{#{v}}" }.symbolize_keys!
    p "locale_keys_to_code_keys"
    p locale_keys_to_code_keys

    message_with_accessor_keys_translated_to_code_domain = custom_activity_type.message_template % locale_keys_to_code_keys
    p "message_with_accessor_keys_translated_to_code_domain"
    p message_with_accessor_keys_translated_to_code_domain

    code_keys_to_corresponding_values = code_keys_to_corresponding_values.symbolize_keys.transform_values { |v| "<b>#{v}</b>".html_safe }
    p "code_keys_to_corresponding_values"
    p code_keys_to_corresponding_values

    self.message = message_with_accessor_keys_translated_to_code_domain % code_keys_to_corresponding_values
  end

  def determine_message_for_predefined_type
    self.message = I18n.t(
        "activities.messages.#{activity_type}",
        { user_full_name: user.full_name }.merge(translation_params)
    )
  end

  def determine_message
    if custom_activity_type_id
      determine_message_from_custom_type!
    else
      determine_message_for_predefined_type
    end
  end

  private

  def activity_type_xor_custom_activity_type
    return if custom_activity_type_id.present? ^ activity_type.present?
    errors.add(:activity_type, 'There should be either predefined activity_type enum set or associated custom_activity_type')
    errors.add(:custom_activity_type_id, 'There should be either predefined activity_type enum set or associated custom_activity_type')
  end

  def notify_about_activity
    BroadcastActivityJob.perform_later(id)
  end


  # Wydarzenie "Wynajem auta" zostało stworzone przez użtkownika Wojtek Pośpieszyński dnia 23.04.1202
  # Wydarzenie "Zwrot auta" zostało stworzone przez użtkownika Wojtek Pośpieszyński dnia 24.04.1202. Zobacz notkę autora.
  #
  # auto -> InventoryItem -> CustomActivityType -> optional_target
  #
  # CustomActivityType: driving_school, name, optional_target_class, message_template, activity_receivers
  # ex: 12, "InventoryItem", "Car rental", "%{user_name} zglosił wynajęcia auta %{car_name}"
  # name should be "bezokolicznik"
  # target => "message_template".replace(target.activity_props) --> message
  #
  # activity_props - { car_name: name }
  # car_name etc. should all have a column name translations to be properly displayed on a CustomActivityType form
  #
  # -- Report car rental request -- > [custom_activity_type_id, target_id, comment]
  #
  #
  # activity_receivers? Prepare some static options i.e "Owners", "Instructors", "Office Employees", "All Employees"
  #
  # Endpoint for testing the template string against some example data to make sure message builder is to be working fine in future. We can *build*
  # a record in InventoryItem and provide it to some building function to imitate the way its gonna be used when reporrting functionality is up
  # Show this example ona form before submission
  #
  # On Quick Actions screen
  # 1. Fetch CustomActivityType records
  # 2. Based on that records render buttons "Report #{CustomActivityType -> name}" (id)

  def translation_params
    case activity_type
      when 'student_invitation_sent', 'student_invitation_withdrawn'
        {
          student_full_name: target.student_full_name,
          student_email: target.student_email
        }
      when 'employee_invitation_sent', 'employee_invitation_withdrawn'
        {
          employee_full_name: target.employee_full_name,
          employee_email: target.employee_email
        }
      when 'driving_course_changed'
        {
          student_full_name: target.student_driving_school.student.full_name,
          available_slot_credits: target.available_slot_credits
        }
      when 'schedule_changed'
        {
          employee_full_name: target.employee_driving_school.employee.full_name
        }
      when 'driving_lesson_canceled', 'driving_lesson_scheduled'
        {
          duration: target.display_duration,
          student_full_name: target.student.full_name,
          employee_full_name: target.employee.full_name
        }
      else
        {}
    end
  end
end
