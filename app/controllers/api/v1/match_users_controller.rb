module Api
  module V1
    class MatchUsersController < ApplicationController
      def index
        @users = User.by_gender(current_user.gender, current_user.prefer_gender_male, current_user.prefer_gender_female)
                     .where.not(id: current_user.id)
                     .by_age(current_user.prefer_min_age, current_user.prefer_max_age)
                     .by_distance([current_user.lat, current_user.lng], current_user.prefer_location_distance)
                     .by_show_in_app(current_user.is_show_in_app)
      end
    end
  end
end