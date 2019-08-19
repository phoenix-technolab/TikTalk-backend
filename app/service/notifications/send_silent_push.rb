module Notifications
  class SendSilentPush
    extend LightService::Organizer
    def self.call(firebase_tokens:, data: {})
      with(
        firebase_tokens: firebase_tokens,
        data: data
      ).reduce(
        Notifications::SendSilentPush::InitializeClient,
        Notifications::SendSilentPush::SendSilentPushToUser
      )
    end 
  end

  class Notifications::SendSilentPush::InitializeClient
    extend LightService::Action
    promises :fcm_client

    executed do |context|
      context.fcm_client = FCM.new(ENV['GOOGLE_FCM_API_KEY'])
    end
  end

  class Notifications::SendSilentPush::SendSilentPushToUser
    extend LightService::Action
    expects :fcm_client, :firebase_tokens, :data
    promises :response
    executed do |context|
      options = {
        data: context.data
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