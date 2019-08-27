module TwilioMethods
  def twilio_service
    twilio_client.chat.services(ENV.fetch("TWILIO_SERVICE_SID"))
  end

  def twilio_client
    @client ||= Twilio::REST::Client.new
  end
end