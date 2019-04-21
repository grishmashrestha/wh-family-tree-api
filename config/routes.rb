Rails.application.routes.draw do
	namespace 'api' do
		namespace 'v1' do
		require 'sidekiq/web'
		mount Sidekiq::Web => "/sidekiq"
			resources :users
		end
	end
end
