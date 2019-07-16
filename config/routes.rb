Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords",
    :confirmations     => "users/confirmations",
    :unlocks     => "users/unlocks"
  }

  root 'application#root' # TODO 仕様書画面作成してそこを指定する.

  namespace 'api' do
    namespace 'v1' do
      get '/restaurant', to: 'restaurants#show'
    end
  end

end
