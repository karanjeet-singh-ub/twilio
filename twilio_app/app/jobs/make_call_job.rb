class MakeCallJob < ActiveJob::Base
  queue_as :default
 
  @@twilio_sid = Rails.application.secrets.twilio_account_sid
  @@twilio_token = Rails.application.secrets.twilio_auth_token
  @@twilio_number = Rails.application.config.twilio_number
 
  def perform(to, url)
    client = Twilio::REST::Client.new @@twilio_sid, @@twilio_token
    call = client.calls.create(
      :from => @@twilio_number,
      :to => to,
      :url => url 
    )
  end
end