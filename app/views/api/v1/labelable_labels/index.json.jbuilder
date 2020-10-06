json.array! @labelable_labels do |ll|
  json.partial! 'labelable_label', ll: ll
end
