Rails.application.routes.draw do
  #get 'subscribers/index'
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
    post '/', to: 'subscribers#create'
    root to: 'pages#home'
  end

end
