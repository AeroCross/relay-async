Rails.application.routes.draw do

  # matched routes
  # messages
  post 'messages/create', to: 'messages#create'
  get 'messages/show/:id', to: 'messages#show'

  # access
  get 'access/', to: 'access#login'
  get 'access/index', to: 'access#login'
  get 'access/login', to: 'access#login'
  get 'access/logout', to: 'access#logout'
  post 'access/attempt', to: 'access#attempt'

  # Chat API
  post 'chat/auth', to: 'chat#auth'

  # root route when URL is accessed by itself
  root to: 'tickets#index'

  # generated with the scaffolding
  resources :tickets
  resources :users

  # ==========================================
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
