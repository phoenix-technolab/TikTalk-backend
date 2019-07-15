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
          
      end
    end
  end
end
