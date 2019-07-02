class UserProfileUpdate
  extend LightService::Organizer
  def self.call(current_user, user_params, profile_params, attachment_params)
    with(current_user: current_user,
         user_params: user_params,
         profile_params: profile_params,
         attachment_params: attachment_params).reduce(
          UserProfileUpdate::UpdateUser,
          UserProfileUpdate::UpdateUserPhotos,
          UserProfileUpdate::UpdateUserProfile
      )
  end
end

class UserProfileUpdate::UpdateUser
  extend LightService::Action
  expects :current_user, :user_params
  promises :current_user

  executed do |context|
    unless context.current_user.update(context.user_params) 
      context.fail_and_return!(context.current_user)
    end
  end

end

class UserProfileUpdate::UpdateUserPhotos
  extend LightService::Action
  expects :attachment_params, :current_user
  promises :current_user

  executed do |context|
   
      context.attachment_params[:add_images]&.each do |image| 
       object = context.current_user.attachments.new(image: image)
       unless object.save
        context.fail_and_return!(object.errors.full_messages) 
       end
      end
    
      context.current_user.attachments.where(id: context.attachment_params[:delete_images]).destroy_all
    
  end
end

class UserProfileUpdate::UpdateUserProfile
  extend LightService::Action
  expects :profile_params, :current_user
  promises :current_user

  executed do |context|
    unless context.current_user.profile.update(context.profile_params)
      context.fail_and_return!(context.current_user.profile.errors)
    end
  end
end
