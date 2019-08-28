class RoomCallbacks::Separate
  extend LightService::Organizer
  def self.call(identity:, room_name:, room_sid:, event:)
    with(
      room_name: room_name,
      room_sid: room_sid,
      identity: identity,
      event: event
    ).reduce(
      RoomCallbacks::Separate::CallRoomCreate,
      RoomCallbacks::Separate::CallStreamService,
    )
  end

  class RoomCallbacks::Separate::CallRoomCreate
    extend LightService::Action
    
    expects :event, :room_name, :room_sid

    executed do |context|
      next unless context.event.eql?("room-created")

      result = RoomCallbacks::CallCreated.call(
        room_name: context.room_name,
        room_sid: context.room_sid
      )

      context.fail_and_return!(result.message) unless result.success?
    end
  end

  class RoomCallbacks::Separate::CallStreamService
    extend LightService::Action
    
    expects :event, :room_name, :identity

    executed do |context|
      classify_status = context.event.underscore.classify

      next if Stream::ROOM_TWILIO_STATUSES.exclude?(classify_status)
  
      result = "Streams::Callbacks::#{classify_status}".constantize.call(
        participant_email: context.identity,
        room_name:         context.room_name
      )

      context.fail_and_return!(result.message) unless result.success?
    end
  end
end