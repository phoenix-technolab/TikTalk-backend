class RoomCallbacks::CallCreated
  extend LightService::Organizer
  def self.call(room_name:)
    with(room_name: room_name).reduce(
      RoomCallbacks::CallCreated::SetFindCallParticipants,
      RoomCallbacks::CallCreated::FindCallParticipants,
      RoomCallbacks::CallCreated::SendPush
    )
  end
  class RoomCallbacks::CallCreated::SetFindCallParticipants
    extend LightService::Action
    
    expects :room_name
    promises :callee_email, :caller_email, :divider_count

    executed do |context|
      context.divider_count = context.room_name.count("\\")
      divider               = "\\" * context.divider_count
      context.callee_email  = context.room_name.split(divider).first
      context.caller_email  = context.room_name.split(divider).last
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

    expects :callee, :caller

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
        caller_id:     context.caller.id,
        caller_name:   context.caller.name,
        caller_email:  context.caller.email,
        caller_phone:  context.caller.phone_number,
        caller_avatar: context.caller.attachments.first.image.url
      }
    end
  end
end