Rails.application.routes.draw do
  
  get 'contacts/create'
  get 'dashboard/index'
  get 'shifts/edit_schedule', to: 'shifts#edit_schedule', as: 'edit_schedule'
  # エクセル出力
  get 'shifts/export_excel', to: 'shifts#export_excel', defaults: { format: :xlsx }, as: 'export_excel'
  # プライバシーポリシー
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'inquiry', to: 'static_pages#inquiry'
  
  post 'shifts/create_schedule', to: 'shifts#create_schedule', as: 'create_schedule'
  patch 'shifts/update_schedule', to: 'shifts#update_schedule', as: 'update_schedule'
  delete 'shifts/destroy_all', to: 'shifts#destroy_all', as: 'destroy_all_shifts'
  
  # トップページ
  get 'tops/index'
  root 'tops#index'
  
  # ダッシュボード
  get 'dashboard/index'

  # ユーザー登録画面
  resources :users, only: %i[new create]

  # スタッフ管理画面
  resources :employees do
    member do
      patch :move_up
      patch :move_down
    end
  end

  # シフト管理画面
  resources :shifts, only: %i[index new create edit update]

  # 勤務希望入力画面
  resources :shift_requests, only: %i[new create destroy edit update]

  # お問い合わせフォーム
  resources :contacts, only: [:new, :create]

  # ログイン画面
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'

  # ログアウト
  delete 'logout', to: 'user_sessions#destroy'
end
