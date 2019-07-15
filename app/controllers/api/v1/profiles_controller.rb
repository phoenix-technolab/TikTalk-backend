module Api
  module V1
    class ProfilesController < ApplicationController
      def update
        result = UserProfile::UserProfileUpdate.call(current_user, 
                                                     user_params, 
                                                     profile_params, 
                                                     profile_notifications_params, 
                                                     update_attachment_params)

        return render_error(result.message) unless result.success?
        @current_user = result.current_user
      end

      def instagram_connect
        result = UserProfile::FetchInstagramPhotoUrl.call(current_user, instagram_params)
        return render_error(result.message) unless result.success?
        @current_user = result.current_user
      end

      private

      def instagram_params
        params.permit(:access_token)
      end

      def user_params
        params.permit(:name, :birth_date, :gender)
      end

      def profile_notifications_params
        params.require(:notifications).permit(:pause_all, 
                                              :messages,
                                              :new_matches, 
                                              :like_you, 
                                              :message_in_private_room, 
                                              :super_like)
      end

      def profile_params
        params.permit(:work, :education, :about_you, :relationship,
                      :sexuality, :height, :living, :children,
                      :smoking, :drinking, speak:[])
      end

      def update_attachment_params
        params.permit(add_images:[], delete_images:[])
      end
    end
  end
end

