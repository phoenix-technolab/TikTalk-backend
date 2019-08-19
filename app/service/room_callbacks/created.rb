class RoomCallbacks::Created
  extend LightService::Organizer
  def self.call(room_name)
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
      context.callee = User.joins(:profile).where('profiles.twilio_user_id': context.callee_sid)
      context.caller = User.joins(:profile).where('profiles.twilio_user_id': context.caller_sid)

      next if context.callee.present?

      context.fail_and_return!("Callee doesn't exist")
    end
  end
  class RoomCallbacks::Created::SendPush
    extend LightService::Action

    expects :callee, :caller

    executed do |context|
      firebase_token = context.callee.firebase_token

      opts = { message: "#{context.caller&.name} calling you" } 
      data = {}

      Notifications::SendNotifications.call(firebase_token, opts, data)
    end
  end
end