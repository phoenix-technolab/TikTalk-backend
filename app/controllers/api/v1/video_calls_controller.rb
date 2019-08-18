class Api::V1::VideoCallsController < ApplicationController
  skip_before_action :authentication!, only: :room_status_callback
  include TwilioMethods

  def create
    token = Twilio::JWT::AccessToken.new(ENV.fetch("TWILIO_ACCOUNT_SID"),
                                          ENV.fetch("TWILIO_API_KEY"),
                                          ENV.fetch("TWILIO_API_SECRET"),
                                          identity: current_user.email)

    grant = Twilio::JWT::AccessToken::VideoGrant.new
    token.add_grant(grant)

    render json: { token: token.to_jwt }
  end

  def room_status_callback
    return unless callback_params[:StatusCallbackEvent].eql?("room-created")

    result = RoomCallbacks::Created.call(
      room_name: callback_params[:RoomName]
    )
    render json_service_messages(result) unless result.success?
  end

  private

  def callback_params
    params.permit(
      :StatusCallbackEvent, :RoomName
    )
  end
end
