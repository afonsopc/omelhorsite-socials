# frozen_string_literal: true

Rails.application.routes.draw do
  get '/friendships', to: 'friendships#show'
  post '/friendship', to: 'friendships#create'
  patch '/friendship', to: 'friendships#accept'
  delete '/friendship', to: 'friendships#end'

  get '/settings', to: 'settings#show'
  patch '/settings', to: 'settings#update'

  get '/blocks', to: 'blocks#show'
  post '/block', to: 'blocks#block'
  delete '/block', to: 'blocks#unblock'

  get '/conversations', to: 'messages#conversations'
  get '/conversation', to: 'messages#conversation'
  delete '/conversation', to: 'messages#delete_conversation'
  post '/message/text', to: 'messages#send_text_message'
  post '/message/image', to: 'messages#send_image_message'

  root 'root#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
