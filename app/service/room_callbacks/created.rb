class RoomCallbacks::Created
  extend LightService::Organizer
  def self.call(room_name)
    with(
      callee_id: room_name.split('_').first,
      caller_id: room_name.split('_').last
    ).reduce(
      RoomCallbacks::Created::FindCallParticipants,
      RoomCallbacks::Created::SendPush
    )
  end

  class RoomCallbacks::Created::FindCallParticipants
    extend LightService::Action
    expects :callee_id, :caller_id
    promises :callee, :caller

    executed do |context|
      context.callee = User.find_by(id: context.callee_id)
      context.caller = User.find_by(id: context.caller_id)

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