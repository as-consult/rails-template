Rails.application.routes.draw do
  #get 'subscribers/index'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :contacts, only: [ :new, :create, :index ]
    resources :blogs
    devise_for :users
    get 'apropos/index'
    get 'faqs/index'
    get 'services/index'
    get 'subscribers/index'
    get 'cgv/index'
    get 'politique_confidentialite/index'
    get 'mentions_legales/index'
    post '/', to: 'subscribers#create'
    get 'subscribers/unsubscribe/:unsubscribe_hash', to: 'subscribers#unsubscribe', as: 'unsubscribe'
    get 'pages/console'
    get 'blog_views/index'
    root to: 'pages#home'
  end

end
