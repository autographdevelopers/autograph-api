class Employee < User
  # == Relations ==============================================================
  has_many :employee_driving_schools
  has_many :driving_schools, through: :employee_driving_schools
end
