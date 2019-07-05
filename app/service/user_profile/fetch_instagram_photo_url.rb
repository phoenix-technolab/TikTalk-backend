require 'net/http'

class UserProfile::FetchInstagramPhotoUrl
  extend LightService::Organizer
  def self.call(current_user, instagram_params)
    with(current_user: current_user,
         instagram_params: instagram_params).reduce(
          UserProfile::FetchInstagramPhotoUrl::CallInstagramApi,
          UserProfile::FetchInstagramPhotoUrl::BuildData
      )
  end
end

class UserProfile::FetchInstagramPhotoUrl::CallInstagramApi
  extend LightService::Action
  expects :instagram_params
  promises :response

  executed do |context|
    uri = URI("https://api.instagram.com/v1/users/self/media/recent?access_token=#{context.instagram_params[:access_token]}")
    response = Net::HTTP.get(uri)
    context.response = JSON.parse(response)
    if context.response.dig("meta", "error_message")
      context.fail_and_return!(context.response.dig("meta", "error_message"))
    end
  end
end

class UserProfile::FetchInstagramPhotoUrl::BuildData
  extend LightService::Action
  expects :current_user, :response
  promises :current_user

  executed do |context|
    user_images = context.response["data"].map{|media| media.dig("images", "standard_resolution","url") if media["type"].eql?("image")}.compact
    context.current_user.profile.update(instagram_photos_url: user_images)
  end
end
