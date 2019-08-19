module Notifications
  class SendNotifications
    extend LightService::Organizer
    def self.call(firebase_tokens:, params:, data: {})
      with(
        firebase_tokens: firebase_tokens,
        params: params,
        data: data
      ).reduce(
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
    expects :fcm_client, :firebase_tokens, :params, :data
    promises :response
    executed do |context|
      options = {
        notification: {
          data: context.data,
          title: 'TikTalk',
          body: context.params
        }
      }
      context.response =  context.fcm_client.send([context.firebase_tokens], options)

      pp "=" * 100
      pp context.response
      pp "=" * 100
      pp options
      pp "=" * 100
    end
  end
end