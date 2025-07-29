Rails.application.routes.draw do
  
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "home",  to: "static_pages#home",  as: :home
    get "help",  to: "static_pages#help",  as: :help
    get "login", to: "static_pages#login", as: :login

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    resources :users, only: %i(new create show)
    resources :products
  end
end
