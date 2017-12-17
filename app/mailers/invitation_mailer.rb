class InvitationMailer < ApplicationMailer
  def cooperation_email(email, user_type, user_already_exists, driving_school)
    @email = email
    @user_type = user_type
    @user_already_exists = user_already_exists
    @driving_school = driving_school
    mail(to: email, subject: 'Request for cooperation')
  end
end
