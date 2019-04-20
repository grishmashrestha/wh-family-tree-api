module Api
	module V1
		class UsersController < ApplicationController
			def index
				users = User.order('created_at DESC')
				render json: {status: 'Success', message: 'Loaded users', data: users}, status: :ok
			end

			def create
				file =  params[:file]
				User.import(file)
				users = User.order('created_at DESC')
				render json: {status: 'Success', message: 'Loaded users', data: users}, status: :ok
			end

		end

	end

end
