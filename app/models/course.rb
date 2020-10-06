class Course < ApplicationRecord
  has_many :course_participations
  belongs_to :driving_school
  belongs_to :type, class_name: 'Label', foreign_key: :label_id
end
