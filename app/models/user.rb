require 'csv'
class User < ApplicationRecord
	has_many :sons, class_name: "User", foreign_key: "father_id"
	belongs_to :father, class_name: "User", optional: true

	def self.import(path)
		# open the file
		csv_file = File.open(path, "r")
		CSV.foreach(csv_file, col_sep: "\t", headers: true) do |row|  
			self.import_each(row)
		end
		User.all.includes(:sons, :father)
	end
	
	def self.import_each(row)
		grandfather = User.find_by_full_name(row[0])
        father = User.find_by_full_name(row[1])
        son = User.find_by_full_name(row[2])
		if grandfather.nil? 
			# create new grandfather
			grandfather = User.create(full_name: row[0])
			if father.nil?
				father = User.create(full_name: row[1])
				grandfather.sons << father
				
				son = User.create(full_name: row[2], address: row[3])
				father.sons << son
			else 
				# if father already has a father_id
				if father.father_id?
					father = User.create(full_name: row[1])
				end
				grandfather.sons << father

				son = User.create(full_name: row[2], address: row[3])
				father.sons << son
			end
		else 
			if father.nil?
				father = (User.create(full_name: row[1]))
				grandfather.sons << father
				son = User.create(full_name: row[2], address: row[3])
				father.sons << son
			 else
				 if grandfather.is_a_father_of(father)
					 if son.nil?
						 son = User.create(full_name: row[2], address: row[3])
						father.sons << son
					 else
						 if father.is_a_father_of(son)
							 # do nothing
						 else
							 son = User.create(full_name: row[2], address: row[3])
							father.sons << son
						 end
					 end
				 else
					 father = (User.create(full_name: row[1]))
					grandfather.sons << father
					son = User.create(full_name: row[2], address: row[3])
					father.sons << son
				 end
			end
		end
	end

	def is_a_father_of(unverified_son)
    	self.sons.include?(unverified_son)
    end
end
