class Student < User
  # == Relations ==============================================================
  has_many :student_driving_schools
  has_many :driving_schools, through: :student_driving_schools
  has_many :driving_lessons

  # == Aliases ================================================================
  alias_attribute :user_driving_schools, :student_driving_schools

  # == Callbacks ==============================================================
  after_create :find_pending_invitation_and_relate_user_to_driving_school

  # == Instance Methods =======================================================
  private

  def find_pending_invitation_and_relate_user_to_driving_school
    invitations = Invitation.where('lower(email) = ?', self.email)

    ActiveRecord::Base.transaction do
      invitations.each do |invitation|
        invitation.invitable.update(student: self)
      end

      invitations.destroy_all
    end
  end
end
