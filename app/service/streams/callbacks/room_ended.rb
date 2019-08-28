class Streams::Callbacks::RoomEnded
  extend LightService::Organizer

  def self.call(room_name:, participant_email:)
    with(
      room_name: room_name
    ).reduce(
      Streams::Callbacks::RoomEnded::FindEntities,
      Streams::Callbacks::RoomEnded::DestroyStream
    )
  end

  class Streams::Callbacks::RoomEnded::FindEntities
    extend LightService::Action

    expects :room_name
    promises :stream

    executed do |context|
      user_id        = context.room_name.split("\\").last
      context.stream = User.find(user_id)&.stream

      context.fail_and_return!("You have no active streams") if context.stream.nil?
    end
  end

  class Streams::Callbacks::RoomEnded::DestroyStream
    extend LightService::Action

    expects :stream

    executed do |context|
      context.fail_and_return!(context.stream.errors) unless context.stream.destroy
    end
  end
end