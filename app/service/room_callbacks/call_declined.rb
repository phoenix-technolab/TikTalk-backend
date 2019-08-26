class RoomCallbacks::CallDeclined
  extend LightService::Organizer
  def self.call(group_name:, declined_by_email:, room_sid:)
    with(
      declined_by_email: declined_by_email,
      group_name:        group_name,
      room_sid:          room_sid
    ).reduce(
      RoomCallbacks::CallDeclined::SetFindCallParticipants,
      RoomCallbacks::CallDeclined::FindCallParticipants,
      RoomCallbacks::CallDeclined::SendPush
    )
  end
  class RoomCallbacks::CallDeclined::SetFindCallParticipants
    extend LightService::Action

    expects :group_name
    promises :callee_email, :caller_email, :divider_count, :channel_sid

    executed do |context|
      context.divider_count = context.group_name.count("\\")
      divider               = "\\" * context.divider_count
      context.callee_email  = context.group_name.split(divider).first
      context.caller_email  = context.group_name.split(divider).second
      context.channel_sid   = context.group_name.split(divider).third


      pp "=" * 100
      pp context.callee_email
      pp "=" * 100
      pp context.caller_email
      pp "=" * 100
      pp context.channel_sid
      pp "=" * 100
      
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

    expects :callee, :caller, :declined_by_email, :room_sid

    executed do |context|
      receiver       = context.declined_by_email.eql?(context.caller.email) ? context.callee : context.caller
      firebase_token = receiver.firebase_token
      opts           = "#{context.caller&.name} calling you"
      data           = push_data(context)

      Notifications::SendSilentPush.call(
        firebase_tokens: firebase_token,
        data:            data
      )
    end
    
    def self.is_audio?(context)
      context.divider_count.eql?(2) ? true : false
    end

    def self.push_data(context)
      {
        type:              "onCancelledCallInvite",
        room_sid:          context.room_sid,
        channel_sid:       context.channel_sid,
        declined_by_email: context.declined_by_email,
        only_audio:        is_audio?(context),
        caller_id:         context.caller.id
      }
    end
  end
end