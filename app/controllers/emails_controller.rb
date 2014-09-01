class EmailsController < ApplicationController
  def slack
    events = JSON.parse(params['mandrill_events'])
    event = events[0]

    if event && event['event'] == 'inbound'
      message = event['msg']

      text = <<-TEXT
        *ACCESS REQUEST*: #{message['from_email']} -> #{message['subject']}\n\n#{message['text']}
      TEXT

      Slack.message('#invites', 'slackbox', text)
    end
  end

  def team
    events = JSON.parse(params['mandrill_events'])
    event = events[0]

    if event && event['event'] == 'inbound'
      message = event['msg']

      ForwardMailer.team({
        to: 'chad.pry@gmail.com',
        from: "#{message['from_name']} <#{message['from_email']}>",
        subject: "FWD: #{message['subject']}",
        html_body: message['html']
      })
    end
  end
end
