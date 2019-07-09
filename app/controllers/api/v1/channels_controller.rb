module Api
  module V1   
    class ChannelsController < ApplicationController
      include TwilioMethods

      def index
        @channels = twilio_service.users(current_user.profile.twilio_user_id)
                                  .user_channels.list
      end
    end
  end
end
