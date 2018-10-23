Rails.application.routes.draw do
  get '/ping', to: 'application#ping'

  resources :runs, except: [:new, :show, :update] do
    collection do
      delete :clear # clear all runs
    end

    resources :tests, only: [:index] do
      collection do
        get :pop # pop n-number of tests from queue
      end
    end
  end
end
