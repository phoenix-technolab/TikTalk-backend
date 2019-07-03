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

      def preference
        @preference = current_user.like_dislikes.new(vote_params)

        unless @preference.save
          render json: { errors: @preference.errors }
        end
      end

      private

      def vote_params
        params.permit(:receiver_id, :status)
      end
    end
  end
end