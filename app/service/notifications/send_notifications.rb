module Notifications
  class SendNotifications
    extend LightService::Organizer
    def self.call(firebase_tokens, params)
      with(firebase_tokens: firebase_tokens,
           params: params).reduce(
            Notifications::SendNotifications::InitializeClient,
            Notifications::SendNotifications::SendNotificationsToUser
        )
    end 

   

  end

  class Notifications::SendNotifications::InitializeClient
    extend LightService::Action
    promises :fcm_client

    executed do |context|
      context.fcm_client = FCM.new(ENV['GOOGLE_FCM_API_KEY'])
    end
  end

  class Notifications::SendNotifications::SendNotificationsToUser
    extend LightService::Action
    expects :fcm_client, :firebase_tokens, :params
    promises :response
    executed do |context|
      context.response =  context.fcm_client.send(context.firebase_tokens, 
        {
          priority: 'high',
          notification: {
              title: 'TikTalk',
              body: context.params
          },
          data: {}
        })
    end
  end

end