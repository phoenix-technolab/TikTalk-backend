class Streams::Callbacks::ParticipantDisconnected
  extend LightService::Organizer

  def self.call(room_name:, participant_email:)
    with(
      room_name:         room_name,
      participant_email: participant_email
    ).reduce(
      Streams::Callbacks::ParticipantDisconnected::FindEntities,
      Streams::Callbacks::ParticipantDisconnected::DeleteParticipantFromStream
    )
  end

  class Streams::Callbacks::ParticipantDisconnected::FindEntities
    extend LightService::Action

    expects :participant_email, :room_name
    promises :participant, :stream

    executed do |context|
      user_id             = context.room_name.split("\\").last
      context.participant = User.find_by(email: context.participant_email)
      context.stream      = User.find(user_id)&.stream

      context.fail_and_return!("You have no active streams") if context.stream.nil?
    end
  end

  class Streams::Callbacks::ParticipantDisconnected::DeleteParticipantFromStream
    extend LightService::Action

    expects :participant, :stream

    executed do |context|
      context.stream.participants.destroy(context.participant)
    end
  end
end