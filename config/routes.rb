PiPlant::Application.routes.draw do

  resources :plant do
    resources :sample, only: [:show, :destroy]
  end

  root 'plants#index'
end
