class UserProfileUpdate
  extend LightService::Organizer
  def self.call(user, user_params, profile_params, attachment_params)
    with(user: user,
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
  expects :user, :user_params

  executed do |context|
    unless context.user.update(context.user_params) 
      context.fail_and_return!(context.user)
    end
  end

end

class UserProfileUpdate::UpdateUserPhotos
  extend LightService::Action
  expects :attachment_params, :user

  executed do |context|
   
    if context.attachment_params[:add_images].present?
      context.attachment_params[:add_images].each do |image| 
       object = context.user.attachments.new(image: image)
       unless object.save
        context.fail_and_return!(object.errors.full_messages) 
       end
      end
    end

    if context.attachment_params[:delete_images].present?
      context.user.attachments.where(id: context.attachment_params[:delete_images]).destroy_all
    end
    
  end
end

class UserProfileUpdate::UpdateUserProfile
  extend LightService::Action
  expects :profile_params, :user
  promises :updated_user

  executed do |context|
    unless context.user.profile.update(context.profile_params)
      context.fail_and_return!(context.user.profile.errors)
    end

    context.updated_user = context.user
  end
end
