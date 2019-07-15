module Api
  module V1
    class VideoCallsController < ApplicationController
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

      def rooms
        room = twilio_client.video.rooms.create(
                                          enable_turn: true,
                                          type: 'peer-to-peer',
                                          unique_name: '3asda'
                                        )
        pp room

      end
    end
  end
end
