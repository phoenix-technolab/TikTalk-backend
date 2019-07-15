Rails.application.routes.draw do

  namespace :api, path: '/' do
    namespace :v1 do
      resources :users, only: [] do
        collection do
          get :status_with_email
          post :auth
          delete :sign_out
          post :twilio_user
          post :twilio_token
          delete :delete_account
        end
      end
      
      resources :phone_verification, only: [] do
        collection do
          post :send_code
          get :verify_code
        end
      end

      resources :user_settings, only: [] do
        collection do
          patch :update
          delete :reset_dislikes
        end
      end

      resources :profiles, only: [] do
        collection do
          patch :update
          get :instagram_connect
        end
      end

      resources :match_users, only: %I(index) do
        collection do
          post :preference
          delete :reset_last
        end
      end
      
      resources :reports, only: %I(create)
      resources :block_users, only: %I(create destroy)
      resources :video_calls, only: %I(create) do
        collection do
          post :rooms
        end
      end
      
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
