class Registration::FindExistUserByPhoneNumber
  extend LightService::Organizer
  def self.call(code)
    with(code: code).reduce(
      Registration::FindExistUserByPhoneNumber::VerifyPhoneNumber,
      Registration::FindExistUserByPhoneNumber::PhoneNumberVerifiedSuccess,
      Registration::FindExistUserByPhoneNumber::FindUser
      )
  end
end

class Registration::FindExistUserByPhoneNumber::VerifyPhoneNumber
  extend LightService::Action
  expects :code
  promises :phone_number
  executed do |context|
    context.phone_number = MyRedis.client.get(context.code)
    next if context.phone_number.present?
    
    context.fail_and_return!({ message: "Incorrect code", status: 400 })
  end
end

class Registration::FindExistUserByPhoneNumber::FindUser
  extend LightService::Action
  expects :phone_number  
  promises :user

  executed do |context|
    context.user = User.where("CONCAT(code_country,phone_number) = ?", context.phone_number).take

    next if context.user.blank?

    if context.user&.is_account_block
      context.fail_and_return!({ message: "Your account has been blocked. For more info Contact Support", status: 403 }) 
    end

    if context.user.present?
      context.user.create_new_auth_token
      context.user.save
      context.skip_remaining!
    end
  end
end

class Registration::FindExistUserByPhoneNumber::PhoneNumberVerifiedSuccess
  extend LightService::Action
  expects :phone_number

  executed do |context|
    MyRedis.client.set(context.phone_number, true, { ex: 1.hour.to_i }) 
    context.fail_and_return!({ message: "Phone number verified", status: 200 })
  end
end
