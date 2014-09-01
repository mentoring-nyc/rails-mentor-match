require 'erb'
require 'pony'

module MentorMatch
  class UserMailer
    def self.signup(name, email, role)
      role = "student" unless role == "mentor"

      template = ERB.new(File.read(Rails.root.join('app/views/user_mailer', "#{__method__}.erb")))

      if role == "mentor"
        message = <<-EOF
          Your signup, to be a mentor, was received and we are seeking a student
          for you. &nbsp;If you have any questions in the meantime, feel free
          to contact us at
          <a href="mailto:team@mentoring-nyc.com">team@mentoring-nyc.com</a>.
        EOF
      else
        message = <<-EOF
          Your signup, to be a student, was received and we are seeking a mentor
          for you. &nbsp;If you have any questions in the meantime, feel free
          to contact us at
          <a href="mailto:team@mentoring-nyc.com">team@mentoring-nyc.com</a>.
        EOF
      end

      message += <<-EOF
        <br><br>
        Would you like to join our slack team?  Benefits include meeting more of the
        community and being able to ask questions in realtime chat.  If so, send an
        email to
        <a href="mailto:slack@mentoring-nyc.com">slack@mentoring-nyc.com</a> and
        we will set you up!
      EOF

      Pony.mail({
        to: "#{name} <#{email}>",
        subject: "Mentoring NYC #{role.capitalize} Signup",
        attachments: {
          "mentor-stormtrooper.jpg" => File.read(Rails.root.join('public/images/emails/mentor-stormtrooper.jpg'))
        },
        html_body: template.result(binding)
      })
    end
  end
end
