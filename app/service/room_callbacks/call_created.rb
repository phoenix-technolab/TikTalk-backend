class RoomCallbacks::CallCreated
  extend LightService::Organizer
  def self.call(room_name:, room_sid:)
    with(
      room_name: room_name,
      room_sid: room_sid
    ).reduce(
      RoomCallbacks::CallCreated::SetFindCallParticipants,
      RoomCallbacks::CallCreated::FindCallParticipants,
      RoomCallbacks::CallCreated::SendPush
    )
  end
  class RoomCallbacks::CallCreated::SetFindCallParticipants
    extend LightService::Action
    
    expects :room_name
    promises :callee_email, :caller_email, :divider_count, :channel_sid

    executed do |context|
      context.divider_count = context.room_name.count("\\")
      divider               = "\\" * context.divider_count
      context.callee_email  = context.room_name.split(divider).first
      context.callee_email  = context.room_name.split(divider).second
      context.channel_sid   = context.room_name.split(divider).third
    end
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

    expects :callee, :caller, :room_sid

    executed do |context|
      firebase_token = context.callee.firebase_token

      opts = "#{context.caller&.name} calling you"
      data = push_data(context)

      Notifications::SendSilentPush.call(
        firebase_tokens: firebase_token,
        data: data
      )
    end

    def self.is_audio?(context)
      context.divider_count.eql?(2) ? true : false
    end

    def self.push_data(context)
      {
        only_audio:    is_audio?(context),
        type:          "onCallInvite",
        room_sid:      context.room_sid,
        caller_id:     context.caller.id,
        caller_name:   context.caller.name,
        channel_sid:   context.channel_sid,
        caller_email:  context.caller.email,
        caller_phone:  context.caller.phone_number,
        caller_avatar: context.caller.attachments.first.image.url
      }
    end
  end
end