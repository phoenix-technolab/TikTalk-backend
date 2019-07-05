class Choices::ItsMatch
  extend LightService::Organizer
  def self.call(vote_params, current_user)
    with(vote_params: vote_params,
         current_user: current_user).reduce(
          Choices::ItsMatch::SaveChoice,
          Choices::ItsMatch::UserMatches,
          ItsMatch::SuperLikeNotification
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

class Choices::ItsMatch::UserMatches
  extend LightService::Action
  expects :current_user, :choice

  executed do |context|
    next if context.choice.dislike? || context.choice.super_like?

    match_user = context.choice.receiver.like_dislikes.where(receiver_id: context.current_user.id)
    context.skip_remaining!({ user: match_user, message: "It`s match", status: 201 }) if match_user.present?
  end
end

class Choices::ItsMatch::SuperLikeNotification
  extend LightService::Action
  expects :choice

  executed do |context|

    next if context.choice.dislike?

    receiver_firebase_token = context.choice.receiver.firebase_token
    opts = { message: "#{context.choice.user.name} send super-like to you" }
    Notifications::SendNotifications.call(receiver_firebase_token, opts)
    
  end
end
