Rails.application.routes.draw do

  devise_for :users

  root 'welcom#manual'

  namespace 'api' do
    namespace 'v1' do
      get '/restaurant', to: 'restaurants#show'
    end
  end

end
