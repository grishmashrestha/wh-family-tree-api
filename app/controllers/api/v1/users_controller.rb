module Api
	module V1
		class UsersController < ApplicationController

			def index
				users = User.order('created_at DESC')
				render json: {status: 'Success', message: 'Loaded users', data: users}, status: :ok
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
				ReportWorker.perform_async(path)
				render json: {status: 'Success', message: 'The CSV is being loaded'}, status: :ok
			end

		end

	end

end
