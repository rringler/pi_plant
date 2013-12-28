PiPlant::Application.routes.draw do

  resources :plants do
    resources :samples, only: [:show, :destroy]
  end

  root 'plants#index'
end
