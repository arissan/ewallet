Rails.application.routes.draw do

  get 'pages/index'

  root to: "pages#index"

  namespace :dashboard do
    namespace :stock do
      get 'subjects/index'
    end
  end

  namespace :dashboard do
    namespace :team do
      get 'subjects/index'
    end
  end

  namespace :dashboard do
    namespace :stock do
      get 'subjects/show'
    end
  end

  namespace :dashboard do
    namespace :stock do
      get 'subjects/new'
    end
  end

  devise_for :stocks
  devise_for :teams
  

  namespace :dashboard do
    authenticated :team do
      resources :subjects, module: "team", :only => [:show, :index]
    end

    authenticated :stock do
      resources :subjects, module: "stock"
    end

    # root to: "dashboard#index"
  end

   namespace :transaction do
    namespace :transaction do
      get 'transfer'
      post 'do_transfer'
      get 'deposit'
      post 'do_deposit'
      get 'withdrawal'
      post 'do_withdrawal'
    end
  end

end
