Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    # APIに大きな変更が発生する場合に備えてスイッチングしやすいようにURL自体にバージョンを持たせる。ただし、「必要な場合にのみ」つけることが推奨されている。
    namespace :v1 do
      resources :restaurants do
        resources :foods, only: %i[index]
      end
      resources :line_foods, only: %i[index create]
      put 'line_foods/replace', to: 'line_foods#replace'
      resources :orders, only: %i[create]
    end
  end

end
