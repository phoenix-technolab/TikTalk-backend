class Streams::Create
  extend LightService::Organizer
  def self.call(twilio_client:, current_user:, lat:, lon:)
    with(
      twilio_client: twilio_client,
      current_user: current_user,
      lat:          lat,
      lon:          lon
    ).reduce(
      Streams::Create::CreateTwilioRoom,
      Streams::Create::CreateStream,
    )
  end

  class Streams::Create::CreateTwilioRoom
    extend LightService::Action
    
    expects :twilio_client, :current_user
    promises 

    executed do |context|
      context.twilio_client.video.rooms.create(
        record_participants_on_connect: true,
        status_callback: "#{ENV["HOST"]}/v1/streams/callback",
        type: 'group',
        unique_name: room_name(context.current_user)
      )
    rescue Twilio::REST::RestError => e      
      context.fail_and_return!(e.error_message)
    end

    def self.room_name(user)
      "#{user.email}\\#{user.id}"
    end
  end

  class Streams::Create::CreateStream
    extend LightService::Action
    
    expects :current_user, :lat, :lon
    promises :stream

    executed do |context|
      context.stream = context.current_user.create_stream(
        lat: context.lat, 
        lon: context.lon
      )
    end
  end
end