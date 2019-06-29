module Api
  module V1
    class UserSettingsController < ApplicationController
      def update
        if current_user.update(user_settings_params)
          @current_user = current_user
          render status: 200
        else
          render json: { errors: @user.errors }, status: 422
        end 
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
