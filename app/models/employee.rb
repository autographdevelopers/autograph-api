class Employee < User
  # == Relations ==============================================================
  has_many :employee_driving_schools
  has_many :driving_schools, through: :employee_driving_schools

  # == Callbacks ==============================================================
  after_create :find_pending_invitation

  # == Instance Methods =======================================================
  private

  def find_pending_invitation
    invitations = Invitation.where('lower(email) = ?', self.email)

    ActiveRecord::Base.transaction do
      invitations.each do |invitation|
        invitation.invitable.update(employee: self)
      end

      invitations.destroy_all
    end
  end
end
