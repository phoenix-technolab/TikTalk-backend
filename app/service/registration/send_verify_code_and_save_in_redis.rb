class Registration::SendVerifyCodeAndSaveInRedis
  extend LightService::Organizer

  def self.call(user_phone_number)
    with(user_phone_number: user_phone_number).reduce(
      Registration::SendVerifyCodeAndSaveInRedis::SendCodeToUser,
      Registration::SendVerifyCodeAndSaveInRedis::StoreCodeInRedis
      )
  end
end

class Registration::SendVerifyCodeAndSaveInRedis::SendCodeToUser
  extend LightService::Action
  expects :user_phone_number
  promises :code
  executed do |context|
    begin
      client = Twilio::REST::Client.new
      client.messages.create({
        from: ENV.fetch("TWILIO_PHONE_NUMBER"),
        to: context.user_phone_number,
        body: "Your verification code #{context.code = generate_code}"
      })
    rescue Twilio::REST::TwilioError => e
      context.fail_and_return!(e.message)
    end
  end

  def self.generate_code
    rand(1000..9999)
  end
end

class Registration::SendVerifyCodeAndSaveInRedis::StoreCodeInRedis
  extend LightService::Action
  expects :code, :user_phone_number

  executed do |context|
    MyRedis.client.set(context.code, context.user_phone_number, { ex: 1.hour.to_i })
  end
  
end