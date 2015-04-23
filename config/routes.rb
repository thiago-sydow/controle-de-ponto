Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do

    authenticated :user do
      root 'day_records#index', as: :authenticated_root
      resources :day_records
      resources :closures
    end

    unauthenticated do
      root 'site#index', as: :unauthenticated_root
    end
  end

end
