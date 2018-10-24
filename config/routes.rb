Rails.application.routes.draw do
  get '/ping', to: 'application#ping'

  resources :runs, except: [:new, :show, :update, :destroy] do
    collection do
      delete :_clear, to: 'runs#clear' # clear all runs
    end

    resources :tests, only: [:index] do
      collection do
        get :pop # pop n-number of tests from queue
      end
    end
  end

  delete 'runs/(:id)', to: 'runs#destroy'

  #
  # This route must always be last.
  #
  match '*unmatched', to: 'application#route_not_found', via: :all
end
