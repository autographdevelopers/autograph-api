class Employee < User
  # == Relations ==============================================================
  has_many :employee_driving_schools
  has_many :driving_schools, through: :employee_driving_schools
  has_many :driving_lessons

  # == Aliases ================================================================
  alias_attribute :user_driving_schools, :employee_driving_schools

  # == Callbacks ==============================================================
  after_create :find_pending_invitation_and_relate_user_to_driving_school

  # == Instance Methods =======================================================
  def can_manage_students?(driving_school)
    self.employee_driving_schools.find_by(driving_school: driving_school).employee_privileges.can_manage_students?
  end

  def is_owner?(driving_school)
    self.employee_driving_schools.find_by(driving_school: driving_school).employee_privileges.is_owner?
  end

  private

  def find_pending_invitation_and_relate_user_to_driving_school
    invitations = Invitation.where('lower(email) = ?', self.email)
    invitations.find_each { |invitation| invitation.invitable.update!(employee: self) }
    invitations.destroy_all
  end
end

# TODO: what if invite both: as an employee and student?
# TODO: include status:active in query?