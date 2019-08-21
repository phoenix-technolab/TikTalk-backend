class RoomCallbacks::CallDeclined
  extend LightService::Organizer
  def self.call(group_name:, declined_by_email:)
    with(
      declined_by_email: declined_by_email,
      group_name:        group_name
    ).reduce(
      RoomCallbacks::CallDeclined::SetCalleeAndCallerEmail,
      RoomCallbacks::CallDeclined::FindCallParticipants,
      RoomCallbacks::CallDeclined::SendPush
    )
  end

  class RoomCallbacks::CallDeclined::SetCalleeAndCallerEmail
    extend LightService::Action
    expects :group_name
    promises :callee_email, :caller_email

    executed do |context|

      pp "=" * 100
      pp context.group_name
      pp "=" * 100

      context.callee_email = context.group_name.split("\\").first
      context.caller_email = context.group_name.split("\\").last
    end
  end

  class RoomCallbacks::CallDeclined::FindCallParticipants
    extend LightService::Action
    expects :callee_email, :caller_email, :declined_by_email
    promises :callee, :caller

    executed do |context|
      context.callee = User.find_by(email: context.callee_email)
      context.caller = User.find_by(email: context.caller_email)

      pp "=" * 100
      pp context.callee&.email
      pp "=" * 100
      pp context.caller&.email
      pp "=" * 100

      next if context.callee.present? 

      context.fail_and_return!("Callee doesn't exist")
    end
  end
  
  class RoomCallbacks::CallDeclined::SendPush
    extend LightService::Action

    expects :callee, :caller, :declined_by_email

    executed do |context|
      receiver       = context.declined_by_email.eql?(context.caller.email) ? context.callee : context.caller
      firebase_token = context.receiver.firebase_token
      opts           = "#{context.caller&.name} calling you"
      data           = push_data(declined_by_email)

      Notifications::SendSilentPush.call(
        firebase_tokens: firebase_token,
        data: data
      )
    end

    def self.push_data(email)
      {
        type:              "onCancelledCallInvite",
        declined_by_email: email
      }
    end
  end
end