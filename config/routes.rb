Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do

    authenticated :user do
      root to: redirect('/day_records'), as: :authenticated_root
      resources :day_records, except: [:show] do
        collection do
          get 'async_worked_time', action: :async_worked_time
          get 'export_pdf', action: :export_pdf
          get 'add_now', action: :add_now
        end
      end

      resources :closures, except: [:show]
    end

    unauthenticated do
      root 'site#index', as: :unauthenticated_root
      post '/contato', to: 'site#contact', as: :contact
    end
  end

end
