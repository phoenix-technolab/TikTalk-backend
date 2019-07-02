module Api
  module V1
    class InstagramsController < ApplicationController
      def connect
        result = FetchInstagramPhotoUrl.call(current_user, instagram_params)
        if result.success?
          @current_user = result.current_user
        else
          render json: {errors: result.message}
        end
      end

      private

      def instagram_params
        params.permit(:access_token)
      end
    end
  end
end
