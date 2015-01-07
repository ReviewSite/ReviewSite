ReviewSite::Application.routes.draw do

  resources :reviewing_groups, except: [:show]

  resources :associate_consultants, only: [:index]

  match "/reviews/:review_id/feedbacks/additional",
        to: "feedbacks#new",
        as: "additional_review_feedback",
        via: [:get]

  resources :reviews do
    member do
      get :summary
      get :send_email
    end

    resources :feedbacks, except: [:index] do
      member do
        put :submit
        put :unsubmit
        post :send_reminder
      end

    end

    resources :self_assessments, except: [:index, :show]

    resources :invitations, only: [:new, :create, :destroy] do
      member do
        post :send_reminder
      end
    end
  end

  root to: "welcome#index"

  resources :sessions, only: [:create]

  match "/auth/:provider/callback" => "sessions#callback"

  resources :welcome, only: [:index] do
    collection do
      get "help"
      get "contributors"
    end
  end

  resources :users do
    get :get_users, on: :collection
    get :feedbacks, on: :member
    get :completed_feedback, on: :member
  end

  devise_for :additional_emails

  get 'users/:id/add_email', to: 'users#add_email'
  get 'users/:id/remove_email', to: 'users#remove_email'

  if ENV['OKTA-TEST-MODE']
    match '/set_temp_okta', to: 'sessions#set_temp_okta', via: :post
  end

end
