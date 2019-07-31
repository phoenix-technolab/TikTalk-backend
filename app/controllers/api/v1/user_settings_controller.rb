module Api
  module V1
    class UserSettingsController < ApplicationController
      
      def update
        if current_user.profile.update(user_settings_params)
          render status: 200
        else
          render json: { errors: current_user.errors }, status: 422
        end 
      end

      def reset_dislikes
        current_user.like_dislikes.where(status: "dislike").destroy_all
      end 

      private

      def user_settings_params
        params.permit(:prefer_gender_female, :prefer_gender_male, :prefer_min_age, 
                      :prefer_max_age, :prefer_location_distance, :is_show_in_app,
                      :is_show_in_places)
      end
    end
  end
end
