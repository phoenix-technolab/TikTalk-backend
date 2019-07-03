module Api
  module V1
    class MatchUsersController < ApplicationController
      def index
        @users = User.by_gender(current_user)
                     .where.not(id: current_user.id)
                     .by_age(current_user)
                     .by_distance(current_user)
                     .by_show_in_app
      end

      def like
        @like = current_user.like_dislikes.new(receiver_id:vote_params[:receiver_id],  status: "like")

        unless @like.save
          render json: { errors: @like.errors }
        end
      end

      def dislike
        @dislike = current_user.like_dislikes.new(receiver_id:vote_params[:receiver_id],  status: "dislike")

        unless @dislike.save
          render json: { errors: @dislike.errors }
        end
      end

      private

      def vote_params
        params.permit(:receiver_id)
      end
    end
  end
end