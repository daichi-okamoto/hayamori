Rails.application.routes.draw do
  get 'employees/index'
  get 'employees/new'
  get 'employees/create'
  get 'employees/destroy'
  get 'employees/show'
  get 'employees/update'
  get 'shifts/index'
  get 'shifts/new'
  get 'shifts/create'
  get 'dashboard/index'
  get 'tops/index'
  root 'tops#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
