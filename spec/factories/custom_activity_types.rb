FactoryBot.define do
  factory :custom_activity_type do
    title { 'Car rental' }
    subtitle { 'This is a car renatl event' }
    btn_bg_color { '#fff' }
    message_template { %(The "%{event_name}" has been registered by %{user_name}. Reporter note: %{note}) }
    target_type { InventoryItem.name }
    notification_receivers { :all_employees }
    datetime_input_config { :none }
    text_note_input_config { :none }
    driving_school
  end
end
