class ReportWorker
	include Sidekiq::Worker
	sidekiq_options retry: false
	require 'csv'

	def perform(path)
		# open the file
		csv_file = File.open(path, "r")
		puts "inside worker"
		CSV.foreach(csv_file, col_sep: "\t", headers: true) do |row|  
			puts "inside foreach csv" 	
			User.import_each(row)
		end
	end
end