Rails.application.routes.draw do

  namespace :api, path: '/' do
    namespace :v1 do
      resources :users, only: [] do
        collection do
          get :status_with_email
          post :auth
          delete :sign_out
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
          put :update
        end
      end

      resources :profiles, only: [] do
        collection do
          put :update
          get :instagram_connect
        end
      end

      resources :match_users, only: %I(index) do
        collection do
          post :like
          post :dislike
        end
      end
      
      resources :reports, only: %I(create)
      
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
