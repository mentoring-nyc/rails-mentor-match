class ForwardMailer < ActionMailer::Base
  def slack(options)
    mail options
  end

  def team(options)
    mail options
  end
end
