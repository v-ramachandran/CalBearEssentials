BearEssentials::Application.routes.draw do

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
  #   end  resources :planners

  # RESOURCES FOR PLANNERS
  get "planners/index", :as => 'planners_index'
  get "planners/plan", :as => 'planners_plan'
  get "planners/check", :as => 'planners_check'
  resources :planners, :only => [:index, :destroy]
  match '/planners/show(/:pname)', :to => 'planners#show', :as => "show_planner"
  match '/planners/add(/:pname)', :to => 'planners#add', :as => "add_class_planner"

  # ROUTES FOR THE WELCOME PAGE
  root :to => 'welcome#index'
  get "/index.html" => "welcome#index"
  get "/about" => "welcome#about", :as => 'about'
  get "/contact" => "welcome#contact", :as => 'contact'
  post "/contact" => "welcome#submit", :as => 'contact_submit'

  # ROUTES FOR OMNIAUTH LOGIN
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  match '/auth/failure', :to => 'sessions#failure', :as => 'auth_fail'

  # ROUTES FOR USERS
  resources :users, :only => [:new, :create]

  # match '/', :to => 'application#index'
  #match '/:action', :to => 'application'
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
  # match ':controller(/:action(/:id(.:format)))'
end
