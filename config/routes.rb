Rails.application.routes.draw do
  root to: 'questions#index'

  resource :header_color, only: %i[edit update]

  resources :questions do
    put 'hide', on: :member
  end

  resource :session, only: %i[new create destroy]

  resources :users, except: :index, param: :nickname

  resources :hashtags, only: :show
end
