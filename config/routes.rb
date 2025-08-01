Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'password_resets/create'
  get 'password_resets/update'
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "home",  to: "static_pages#home",  as: :home
    get "help",  to: "static_pages#help",  as: :help

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    get "/users", to: "users#index"
    get "/edit", to: "users#edit"
    put "/edit", to: "users#update"
    delete "/users/:id", to: "users#destroy"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users, only: %i(index new create show edit update destroy)
    resources :products
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
  end
end
