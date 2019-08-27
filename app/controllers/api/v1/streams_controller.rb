class Api::V1::StreamsController < ApplicationController
  def nearby
    @streams = Stream.nearby(
      lat: stream_params[:lat],
      lon: stream_params[:lon]
    )
  end

  def popular
    @streams = Stream.popular
  end

  def create
    result = Streams::Create.call(
      twilio_client: twilio_client,
      current_user:  current_user,
      lat: stream_params[:lat],
      lon: stream_params[:lon]
    )
    @stream = result.stream
    return render_error(result.message) unless result.success?
  end

  def callback
    classify_status = callback_params[:StatusCallbackEvent].underscore.classify

    return if Stream::ROOM_TWILIO_STATUSES.exclude?(classify_status)

    result = "Streams::Callbacks::#{classify_status}".constantize.call(
      participant_email: callback_params[:ParticipantIdentity],
      room_name:         callback_params[:RoomName]
    )
    return render_error(result.message) unless result.success?
  end

  private

  def stream_params
    params.permit(:lon, :lat)
  end

  def callback_params
    params.permit(
      :ParticipantIdentity,
      :StatusCallbackEvent, 
      :RoomName
    )
  end
end