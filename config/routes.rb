Rails.application.routes.draw do

  get 'sessions/create'
  namespace :api, path: '/' do
    namespace :v1 do
      resources :users, only: [:create]
      delete 'sign_out', to: 'users#sign_out'
      get 'send_code',   to: 'phone_verification#send_code'
      get 'verify_code', to: 'phone_verification#verify_code'
      post 'auth',       to: 'users#auth'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
