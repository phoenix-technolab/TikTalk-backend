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
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
