Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :contacts
    resources :blogs
    devise_for :users
    get 'apropos/index'
    get 'faqs/index'
    get 'services/index'
    get 'cgv/index'
    get 'politique_confidentialite/index'
    get 'mentions_legales/index'
    root to: 'pages#home'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
