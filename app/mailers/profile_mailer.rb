class ProfileMailer < ActionMailer::Base
  default from: 'The Mentoring NYC Team <team@mentoring-nyc.com>'

  #   en.profile_mailer.signup.subject
  def signup(name, email, role)
    @name, @email = [name, email]
    attachments.inline['mentor-stormtrooper.jpg'] = File.read(Rails.root.join('app/assets/images/emails/mentor-stormtrooper.jpg'))
    mail to: "#{name} <#{email}>", subject: "Mentoring NYC #{role.capitalize} Signup"
  end
end
