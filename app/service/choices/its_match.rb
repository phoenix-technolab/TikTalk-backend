class Choices::ItsMatch
  extend LightService::Organizer
  def self.call(vote_params, current_user)
    with(vote_params: vote_params,
         current_user: current_user).reduce(
          Choices::ItsMatch::SaveChoice,
          Choices::ItsMatch::LikeNotification,
          Choices::ItsMatch::UserMatches,
          Choices::ItsMatch::ItsMatchNotification,
          Choices::ItsMatch::SuperLikeNotification,
          Choices::ItsMatch::ReturnUserObjectOnMatch
      )
  end
end

class Choices::ItsMatch::SaveChoice
  extend LightService::Action
  expects :vote_params, :current_user
  promises :choice

  executed do |context|
    context.choice = context.current_user.like_dislikes.new(context.vote_params)
    unless context.choice.save
      context.fail_and_return!(context.choice.errors)
    end
    context.current_user.allow_reset!(true)
  end
end

class Choices::ItsMatch::LikeNotification
  extend LightService::Action
  expects :choice, :current_user

  executed do |context|
    ## If user liked someone and receiver have enable notifications or turn off all

    next if context.choice.dislike? || 
            context.choice.super_like? || 
            (!context.choice.receiver.profile.notifications["like_you"] || 
            context.choice.receiver.profile.notifications["pause_all"])
      
    receiver_firebase_token = context.choice.receiver.firebase_token
    opts = { message: "Someone send like to you!" } 
    Notifications::SendNotifications.call(receiver_firebase_token, opts)
  end
end

class Choices::ItsMatch::UserMatches
  extend LightService::Action
  expects :current_user, :choice
  promises :match_user

  executed do |context|
    context.match_user = nil
    next if context.choice.dislike? || context.choice.super_like?
    
    context.match_user = context.choice.receiver.like_dislikes.where(receiver_id: context.current_user.id, status: "like").last
  end
end

class Choices::ItsMatch::ItsMatchNotification
  extend LightService::Action
  expects :match_user, :choice

  executed do |context|
    ## If user liked someone and they had match and receiver had enable notifications or turn off all

    next if context.match_user.blank? || 
            (!context.choice.receiver.profile.notifications["new_matches"] || 
            context.choice.receiver.profile.notifications["pause_all"])

    receiver_firebase_token = context.choice.receiver.firebase_token
    opts = { message: "You with #{context.choice.user.name} matched!" }
    Notifications::SendNotifications.call(receiver_firebase_token, opts)
  end
end

class Choices::ItsMatch::SuperLikeNotification
  extend LightService::Action
  expects :choice

  executed do |context|
    ## If user super liked someone and receiver had enable notifications or turn off all

    next if context.choice.dislike? || 
            context.choice.like? || 
            (!context.choice.receiver.profile.notifications["super_like"] || 
            context.choice.receiver.profile.notifications["pause_all"])

    receiver_firebase_token = context.choice.receiver.firebase_token
    opts = { message: "#{context.choice.user.name} send super-like to you" }
    Notifications::SendNotifications.call(receiver_firebase_token, opts) 
  end
end

class Choices::ItsMatch::ReturnUserObjectOnMatch
  extend LightService::Action
  expects :match_user, :choice

  executed do |context|
    next if context.match_user.blank? || context.choice.dislike? || context.choice.super_like?
  
    context.skip_remaining!({ user: context.match_user.user })
  end

end

