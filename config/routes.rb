ReviewSite::Application.routes.draw do

  resources :reviewing_groups, except: [:show]

  resources :associate_consultants, only: [:index]

  resources :reviews do
    member do
        get :summary
        get :send_email
    end

    resources :feedbacks, :except => [:index] do
      member do
        put :submit
        put :unsubmit
        post :send_reminder
      end

      collection do
        get :additional
      end
    end

    resources :self_assessments, except: [:index, :show]

    resources :invitations, only: [:new, :create, :destroy] do
      member do
        post :send_reminder
      end
    end
  end

  root :to => 'welcome#index'

  resources :sessions, only: [:new, :create, :destroy]

  resources :password_resets, only: [:new, :create, :edit]

  match "/auth/:provider/callback" => "sessions#callback"
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  resources :welcome, :only => [:index] do
    collection do
      get 'help'
      get 'contributors'
      get 'test_error'
    end
  end

  resources :users do
    get :feedbacks, :on => :member
  end

  if ENV['OKTA-TEST-MODE']
    match '/set_temp_okta', to: 'sessions#set_temp_okta', via: :post
  end

end
