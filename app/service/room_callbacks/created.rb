class RoomCallbacks::Created
  extend LightService::Organizer
  def self.call(room_name:)
    with(
      callee_sid: room_name.split('_').first,
      caller_sid: room_name.split('_').last
    ).reduce(
      RoomCallbacks::Created::FindCallParticipants,
      RoomCallbacks::Created::SendPush
    )
  end

  class RoomCallbacks::Created::FindCallParticipants
    extend LightService::Action
    expects :callee_sid, :caller_sid
    promises :callee, :caller

    executed do |context|
      context.callee = User.joins(:profile).where('profiles.twilio_user_id': context.callee_sid).take
      context.caller = User.joins(:profile).where('profiles.twilio_user_id': context.caller_sid).take

      next if context.callee.present?

      context.fail_and_return!("Callee doesn't exist")
    end
  end
  class RoomCallbacks::Created::SendPush
    extend LightService::Action

    expects :callee, :caller

    executed do |context|
      firebase_token = context.callee.firebase_token

      opts = "#{context.caller&.name} calling you"
      data = push_data(context.caller)

      Notifications::SendNotifications.call(
        firebase_tokens: firebase_token, 
        params: opts, 
        data: data
      )
    end

    def self.push_data(caller)
      {
        type: "onCallInvite",
        caller_id: caller.id,
        caller_name: caller.name,
        caller_email: caller.email,
        caller_phone: caller.phone_number
      }
    end
  end
end