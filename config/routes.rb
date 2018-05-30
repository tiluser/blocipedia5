Rails.application.routes.draw do
    root "users#show"
  
  #get 'users' => 'users/index'
  #root 'welcome#index'
    get 'about' => 'welcome#about'
    # get 'welcome/index'

    # get 'welcome/about'
    resources :wikis
    resources :charges, only: [:new, :create]
    resources :downgrades, only: [:create]
    devise_for :users
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    
    # Needed to redirect user after charging with Stripe
    get '/users/:id', :to => 'users#show', :as => :user
end

  
    
