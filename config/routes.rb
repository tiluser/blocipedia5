Rails.application.routes.draw do
    root "users#show"
  
  #root 'welcome#index'
    get 'about' => 'welcome#about'
    # get 'welcome/index'

    # get 'welcome/about'
    resources :wikis
    devise_for :users
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

  
    
