Rails.application.routes.draw do
  get 'shifts/index'
  get 'shifts/new'
  get 'shifts/create'
  get 'dashboard/index'
  get 'tops/index'
  root 'tops#index'

  # ユーザー登録画面
  resources :users, only: %i[new create]

  # スタッフ管理画面
  resources :employees

  # シフト管理画面
  resources :shifts, only: %i[index new create edit update]

  # ログイン画面
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
