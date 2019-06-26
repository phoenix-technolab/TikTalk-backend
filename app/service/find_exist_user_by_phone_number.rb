class FindExistUserByPhoneNumber
  extend LightService::Organizer
  def self.call(code)
    with(code: code).reduce(
          FindExistUserByPhoneNumber::VerifyPhoneNumber,
          FindExistUserByPhoneNumber::FindUser
      )
  end
end

class FindExistUserByPhoneNumber::VerifyPhoneNumber
  extend LightService::Action
  expects :code
  promises :phone_number
  executed do |context|
    context.phone_number = MyRedis.client.get(context.code)
    if context.phone_number.present?
      next
    else
      context.fail_and_return!({ errors: "Incorect code" })
    end
  end
end

class FindExistUserByPhoneNumber::FindUser
  extend LightService::Action
  expects :phone_number  
  promises :user

  executed do |context|
    context.user = User.find_by(phone_number: context.phone_number)
    if context.user.present?
      if context.user.is_account_block.eql?(true)
        context.fail_and_return!({ blocked: "Your account has been blocked. For more info Contact Support" })
      else
        context.user.create_new_auth_token
        context.user.save
        context.skip_remaining!({ user: context.user })
      end
    else
      MyRedis.client.set(context.phone_number, true, { ex: 1.hour.to_i })
      context.fail_and_return!({ success: "Phone number verified" })
    end
  end
end
