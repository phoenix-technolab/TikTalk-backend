class RoomCallbacks::CallCreated
  extend LightService::Organizer
  def self.call(room_name:)
    with(
      callee_email: room_name.split("\\").first,
      caller_email: room_name.split("\\").last
    ).reduce(
      RoomCallbacks::CallCreated::FindCallParticipants,
      RoomCallbacks::CallCreated::SendPush
    )
  end

  class RoomCallbacks::CallCreated::FindCallParticipants
    extend LightService::Action
    expects :callee_email, :caller_email
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
  class RoomCallbacks::CallCreated::SendPush
    extend LightService::Action

    expects :callee, :caller

    executed do |context|
      firebase_token = context.callee.firebase_token

      opts = "#{context.caller&.name} calling you"
      data = push_data(context.caller)

      Notifications::SendSilentPush.call(
        firebase_tokens: firebase_token,
        data: data
      )
    end

    def self.push_data(caller)
      {
        only_audio:    true,
        type:          "onCallInvite",
        caller_id:     caller.id,
        caller_name:   caller.name,
        caller_email:  caller.email,
        caller_phone:  caller.phone_number,
        caller_avatar: caller.attachments.first.image.url
      }
    end
  end
end