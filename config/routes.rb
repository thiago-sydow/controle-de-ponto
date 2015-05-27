Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }, format: false

  devise_scope :user do

    authenticated :user do
      root to: redirect('/day_records'), as: :authenticated_root

      patch 'change_current_account/:id', to: 'accounts#change_current', format: false, as: :change_current_account

      resources :day_records, except: [:show], format: false do
        collection do
          get 'async_worked_time', action: :async_worked_time
          get 'export_pdf', action: :export_pdf
          get 'add_now', action: :add_now
        end
      end

      resources :closures, except: [:show], format: false      
    end

    unauthenticated do
      root 'site#index', as: :unauthenticated_root
      post '/contato', to: 'site#contact', as: :contact, format: false
    end
  end

end