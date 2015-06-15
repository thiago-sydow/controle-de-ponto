Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }, format: false

  devise_scope :user do

    authenticated :user do
      root to: redirect('/day_records'), as: :authenticated_root

      patch 'change_current_account/:id', to: 'accounts#change_current', format: false, as: :change_current_account

      resources :day_records, except: [:show], format: false do
        collection do
          get 'async_worked_time', action: :async_worked_time
          get 'export', action: :export
          post 'add_now', action: :add_now
        end
      end

      resources :closures, except: [:show], format: false
    end

    unauthenticated do
      root 'site#index', as: :unauthenticated_root
      get  '/obrigado', to: 'site#thank_you', as: :thank_you
      post '/contato', to: 'site#contact', as: :contact, format: false
    end
  end

end
