class SendVerifyCodeAndSaveInRedis
  extend LightService::Organizer

  def self.call(code, user_phone_number)
    with(code: code,
         user_phone_number: user_phone_number).reduce(
          SendVerifyCodeAndSaveInRedis::SendCodeToUser,
          SendVerifyCodeAndSaveInRedis::StoreCodeInRedis
      )
  end
end

class SendVerifyCodeAndSaveInRedis::SendCodeToUser
  extend LightService::Action
  expects :code, :user_phone_number

  executed do |context|
    begin
      client = Twilio::REST::Client.new
      client.messages.create({
        from: ENV.fetch("TWILIO_PHONE_NUMBER"),
        to: context.user_phone_number,
        body: "Your verification code #{context.code}"
      })
    rescue Twilio::REST::TwilioError => e
      context.fail_and_return!(e.message)
    end
  end
end

class SendVerifyCodeAndSaveInRedis::StoreCodeInRedis
  extend LightService::Action
  expects :code, :user_phone_number

  executed do |context|
    MyRedis.client.set(context.code, context.user_phone_number, { ex: 1.hour.to_i })
  end
  
end