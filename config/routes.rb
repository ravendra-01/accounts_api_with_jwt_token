Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :account_block do
    resource :accounts do
      collection do
        post :log_in
      end
    end
  end
end
