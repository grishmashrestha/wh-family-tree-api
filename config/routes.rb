Rails.application.routes.draw do

	require 'sidekiq/web'
	mount Sidekiq::Web => "/sidekiq"
	
	namespace 'api' do
		namespace 'v1' do
			resources :users
		end
	end
end
