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
    end
  end
end