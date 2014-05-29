ReviewSite::Application.routes.draw do

  resources :reviewing_groups, except: [:show]

  resources :admin, only: [:index]

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
    # get :autocomplete_coach_name, :on => :collection
  end

  scope :users, :controller => 'users' do
    get 'autocomplete_user_name'
  end

  if ENV['OKTA-TEST-MODE']
    match '/set_temp_okta', to: 'sessions#set_temp_okta', via: :post
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
