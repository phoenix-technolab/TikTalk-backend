class ItsMatch
  extend LightService::Organizer
  def self.call(vote_params, current_user)
    with(vote_params: vote_params,
         current_user: current_user).reduce(
          ItsMatch::SaveChoice,
          ItsMatch::UserMatches
          # ItsMatch::SuperLikeNotification
      )
  end
end

class ItsMatch::SaveChoice
  extend LightService::Action
  expects :vote_params, :current_user
  promises :choice
  executed do |context|
    context.choice = context.current_user.like_dislikes.new(context.vote_params)
    unless context.choice.save
      context.fail_and_return!(context.choice.errors)
    end
    context.current_user.update(can_reset: true)
  end
end

class ItsMatch::UserMatches
  extend LightService::Action
  expects :current_user, :choice

  executed do |context|
    next if context.choice.dislike? || context.choice.super_like?

    sender_user_ids = User.joins(:like_dislikes)
                          .where("like_dislikes.receiver_id = #{context.current_user.id} 
                                  AND like_dislikes.status = 2").ids
    likes_user_matches = context.current_user.like_dislikes.where(receiver_id: sender_user_ids, status: "like")
    last_match_user = likes_user_matches.where(receiver_id: context.choice.receiver_id).last&.receiver

    context.skip_remaining!({ user: last_match_user, message: "It`s match", status: 201 }) if last_match_user.present?
  end
end

class ItsMatch::SuperLikeNotification
  extend LightService::Action
  expects :choice

  executed do |context|

    next if context.choice.dislike?

    receiver_firebase_token = context.choice.receiver.firebase_token
    opts = { message: "#{context.choice.user.name} send super-like to you" }
    Notifications::SendNotifications.call(receiver_firebase_token, opts)
    
  end
end
