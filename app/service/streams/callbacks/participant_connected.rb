class Streams::Callbacks::ParticipantConnected
  extend LightService::Organizer

  def self.call(room_name:, participant_email:)
    with(
      room_name:         room_name,
      participant_email: participant_email
    ).reduce(
      Streams::Callbacks::ParticipantConnected::FindEntities,
      Streams::Callbacks::ParticipantConnected::AddParticipantToStream
    )
  end

  class Streams::Callbacks::ParticipantConnected::FindEntities
    extend LightService::Action

    expects :participant_email, :room_name
    promises :participant, :stream

    executed do |context|
      user_id             = context.room_name.split("\\").last
      context.participant = User.find_by(email: context.participant_email)
      context.stream       = User.find(user_id)&.stream
    end
  end

  class Streams::Callbacks::ParticipantConnected::AddParticipantToStream
    extend LightService::Action

    expects :participant, :stream

    executed do |context|
      context.stream.participants << context.participant
    end
  end
end