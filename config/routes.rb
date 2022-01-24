Rails.application.routes.draw do
  get '/health', to: 'health#health'
  get '/login', to: 'auth#login'
  
  resources :posts, only: %i[index show create update]
end
