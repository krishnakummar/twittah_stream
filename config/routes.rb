TwittahStream::Application.routes.draw do
  resources :tweets, only: [ :index ]
  root 'welcome#index'
end
