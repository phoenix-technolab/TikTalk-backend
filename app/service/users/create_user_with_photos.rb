class Users::CreateUserWithPhotos
  extend LightService::Organizer
  def self.call(user_params, images_params)
    with(user_params: user_params,
         images_params: images_params).reduce(
      Users::CreateUserWithPhotos::CreateUser,
      Users::CreateUserWithPhotos::AddImagesToUser
      )
  end
end

class Users::CreateUserWithPhotos::CreateUser
  extend LightService::Action
  expects :user_params
  promises :user

  executed do |context|
    context.user = User.new(context.user_params)
    context.user.create_new_auth_token
    context.fail_and_return!({ errors: context.user.errors, status: 422 }) unless context.user.save
  end
end

class Users::CreateUserWithPhotos::AddImagesToUser
  extend LightService::Action
  expects :user, :images_params
  executed do |context|
    next if context.images_params[:images].blank?
    
    context.images_params[:images].each do |image| 
      object = context.user.attachments.new(image: image)
      context.fail_and_return!({ errors: object.errors.full_messages, status: 422 }) unless object.save       
    end
  end
end