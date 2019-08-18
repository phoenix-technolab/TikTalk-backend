class RoomCallbacks::Created
  extend LightService::Organizer
  def self.call(callee_id)
    with(callee_id: callee_id).reduce(
      RoomCallbacks::Created::FindCallee,
      RoomCallbacks::Created::SendPush
    )
  end

  class RoomCallbacks::Created::FindCallee
    extend LightService::Action
    expects :callee_id
    promises :callee

    executed do |context|
      context.user = User.find_by(id: context.callee_id)

      next if context.user.present?

      context.fail_and_return!("User doesn't exist")
    end
  end

  class RoomCallbacks::Created::SendPush
    extend LightService::Action
    expects :callee

    executed do |context|
      firebase_token = context.callee.firebase_token

      opts = { message: "call you" } 
      data = {}

      Notifications::SendNotifications.call(firebase_token, opts, data)
    end
  end
end