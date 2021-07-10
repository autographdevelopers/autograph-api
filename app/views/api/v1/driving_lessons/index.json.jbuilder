json.results do
  json.array! @driving_lessons,
              partial: 'api/v1/driving_lessons/driving_lesson',
              as: :driving_lesson
end

json.partial! 'api/v1/helper/pagination', locals: { collection: @driving_lessons }
