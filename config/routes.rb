Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :estates do
        collection do
          get 'search', to: 'estates#search'
        end
      end
    end
  end
end
