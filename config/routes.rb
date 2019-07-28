Rails.application.routes.draw do

  root 'static_pages#welcom'
  get 'manual', to: 'static_pages#manual'


  devise_for :users, :controllers => {
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords",
    :confirmations     => "users/confirmations",
    :unlocks     => "users/unlocks"
  }

  namespace 'api' do
    namespace 'v1' do
      get '/restaurant', to: 'restaurants#show'
    end
  end

end
