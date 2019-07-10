module Api
  module V1
    class MatchUsersController < ApplicationController
      def index
        @users = User.by_gender(current_user)
                     .where.not(id: current_user.id)
                     .by_age(current_user)
                     .by_distance_to_user(current_user)
                     .by_show_in_app
                     .no_display_reported_users(current_user)
                     .no_display_liked_or_disliked(current_user)

       render json: { message: "No one new arround you" } if @users.blank?       
      end

      ## Action for like/dislike user |||| TODO super like and push notification
      def preference
        result = Choices::ItsMatch.call(vote_params, current_user)
        
        if result.success? 
          return render json: { success: true, user: nil } if result.message.blank?

          render partial: "/api/v1/users/user", locals: { user: result.message[:user] }, 
                                                          status: 201 
        else
          render json: result.message, status: 422
        end
      end

      def reset_last
        if current_user.can_reset
          @receiver = current_user.like_dislikes.last&.receiver
          return render_error({ errors: "Can not find" })  if @receiver.blank?
          current_user.like_dislikes.last.destroy
          current_user.allow_reset!(false)
        else
          render json: { message: "You can`t reset users twice" }, status: 403
        end
      end

      private

      def vote_params
        params.permit(:receiver_id, :status)
      end
    end
  end
end