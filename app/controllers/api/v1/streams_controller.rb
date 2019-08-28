class Api::V1::StreamsController < ApplicationController
  def nearby
    @streams = Stream.nearby(
      lat: stream_params[:lat],
      lon: stream_params[:lon]
    )
  end
  
  # TODO: change to popular
  def popular
    @streams = Stream.all #popular
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

  private

  def stream_params
    params.permit(:lon, :lat)
  end
end