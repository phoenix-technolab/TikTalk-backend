class FindExistUserByPhoneNumber
  extend LightService::Organizer
  def self.call(code)
    with(code: code).reduce(
          FindExistUserByPhoneNumber::VerifyPhoneNumber,
          FindExistUserByPhoneNumber::FindUser,
          FindExistUserByPhoneNumber::PhoneNumberVerifiedSuccess
      )
  end
end

class FindExistUserByPhoneNumber::VerifyPhoneNumber
  extend LightService::Action
  expects :code
  promises :phone_number
  executed do |context|
    context.phone_number = MyRedis.client.get(context.code)
    next if context.phone_number.present?
    context.fail_and_return!({ errors: "Incorect code" })
  end
end

class FindExistUserByPhoneNumber::FindUser
  extend LightService::Action
  expects :phone_number  
  promises :user

  executed do |context|
    context.user = User.find_by(phone_number: context.phone_number)
    next if context.user.blank?

    context.fail_and_return!({ blocked: "Your account has been blocked. For more info Contact Support" }) if context.user.present? && context.user.is_account_block.eql?(true)

    if context.user.present?
      context.user.create_new_auth_token
      context.user.save
      context.skip_remaining!({ user: context.user })
    end
  end
end

class FindExistUserByPhoneNumber::PhoneNumberVerifiedSuccess
  extend LightService::Action
  expects :phone_number

  executed do |context|
    MyRedis.client.set(context.phone_number, true, { ex: 1.hour.to_i }) 
    context.fail_and_return!({ success: "Phone number verified" })
  end
end
