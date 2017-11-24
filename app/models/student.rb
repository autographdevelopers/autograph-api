class Student < User
  # == Relations ==============================================================
  has_many :student_driving_schools
  has_many :driving_schools, through: :student_driving_schools
end
