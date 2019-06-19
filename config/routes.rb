Rails.application.routes.draw do
  root to: 'homepage#index'
  post '/', to: 'homepage#create'
end
