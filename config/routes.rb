Rails.application.routes.draw do

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

  authenticated :user do
    root to: "records#index", as: :authenticated_root
    get '/dashboard', to: 'site#dashboard'
  end

  unauthenticated do
    root to: "site#index", as: :unauthenticated_root
  end

  devise_scope :user do
    get "sign_out", :to => 'devise/sessions#destroy'
  end

  resources :records, except: [:show]

  put '/change_date', to: 'records#change_date'

  get '/reports/monthly_report', to: 'reports#monthly_report'
  get '/reports/full_report', to: 'reports#full_report'

end
