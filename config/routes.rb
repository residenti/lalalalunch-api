Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      get '/restaurants', to: 'restaurants#show'
    end
  end
end
