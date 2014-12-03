Rails.application.routes.draw do
  devise_for :users
  get 'posts/index'
  get 'posts/me'
  resources :posts

  root 'site#index'
end
