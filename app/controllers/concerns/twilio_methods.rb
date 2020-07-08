module TwilioMethods
  def twilio_service(name)
    # twilio_client.chat.services(ENV.fetch("TWILIO_SERVICE_SID"))
    puts "=======#{name}"
    twilio_client.chat.services.create(friendly_name: name)
  end

  def twilio_client
    @client ||= Twilio::REST::Client.new
  end
end