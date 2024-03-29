module Api
	module V1
		class UsersController < ApplicationController

			def index
				users = User.all.includes(:sons, :father)
				render json: {status: 'Success', message: 'Loaded users', users: users}, status: :ok
			end

			def create
				file =  params[:file]		
				name = file.original_filename
				directory = "storage/"
				# create the file path
				path = File.join(directory, name)
				# write the file
				csv_file = File.open(path, "wb")
				csv_file.write(file.tempfile.read)
				# ReportWorker.perform_async(path)
				users = User.import(path)
				render json: {status: 'Success', message: 'The CSV is being loaded', users: users}, status: :ok
			end

		end

	end

end
