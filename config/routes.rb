Rails.application.routes.draw do
  get 'employees/index'
  get 'employees/new'
  get 'employees/create'
  get 'employees/destroy'
  get 'employees/show'
  get 'employees/update'
  get 'employees/edit'
  get 'shifts/index'
  get 'shifts/new'
  get 'shifts/create'
  get 'dashboard/index'
  get 'tops/index'
  root 'tops#index'

  # ユーザー登録画面
  resources :users, only: %i[new create]

  # ログイン画面
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
