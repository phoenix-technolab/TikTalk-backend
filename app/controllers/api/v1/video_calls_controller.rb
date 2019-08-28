class Api::V1::VideoCallsController < ApplicationController
  skip_before_action :authentication!, only: :room_status_callback

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
    result = RoomCallbacks::Separate.call(
      identity:  callback_params[:ParticipantIdentity],
      room_name: callback_params[:RoomName],
      room_sid:  callback_params[:RoomSid],
      event:     callback_params[:StatusCallbackEvent]
    )
    return render_error(result.message) unless result.success?
  end

  def decline_call
    result = RoomCallbacks::CallDeclined.call(
      room_sid:          push_params[:room_sid],
      group_name:        push_params[:group_name],
      declined_by_email: push_params[:declined_by_email]
    )
    return render_error(result.message) unless result.success?
  end

  private

  def callback_params
    params.permit(
      :StatusCallbackEvent, 
      :ParticipantIdentity,
      :RoomName, 
      :RoomSid,
    )
  end

  def push_params
    params.permit(:group_name, :declined_by_email, :room_sid)
  end
end
