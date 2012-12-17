require "mkgitignore/version"
require "rest-client"
require "colored"
require "JSON"

$GITIGNORE_URL = "https://api.github.com/repos/github/gitignore/contents/"
$GITIGNORE_FILE_NAME = "a.gitignore"

module Mkgitignore
	def self.templatesFromURL(url)
		begin
			response = RestClient.get(url)
		rescue => e
			begin
				response = JSON.parse(e.response)
				puts "Error: #{ response["message"] }".red
			rescue JSON::ParserError => e
				puts "Failed to connect to Github and to parse error. Error: #{ e.response }".red
			end
			exit
		end

		case response.code
		when 200
			begin
				file_array = Array.new
				JSON.parse(response.body).each do |file_json|
					file_name = file_json["name"].to_s
				  if file_name.include? ".gitignore"
				    file_array << file_json
				  else
				    if file_json["type"] == "dir"
				      file_array += templatesFromURL(file_json["url"])
				    end
				  end 
				end

				file_array.sort! { |x, y| x["name"] <=> y["name"] }
				file_array
			rescue JSON::ParserError => e
				puts "Failed to parse response #{ e.response }".red
			end
		else
			puts "Fail #{ response.code }"
		end
	end

	def self.writeGitignore(gitignore)
		if File.exists?($GITIGNORE_FILE_NAME)
			print("#{ $GITIGNORE_FILE_NAME } already exists. Overwrite? [yn] ")
			flag = gets.to_s

			# Accept any input that starts with a 'y'
		  if !flag.downcase.start_with?("y")
		  	puts "Not overwriting #{ $GITIGNORE_FILE_NAME }".red
		  	puts gitignore
		  	exit
		  end
		end

		file = File.open($GITIGNORE_FILE_NAME, "w")
		file << gitignore
		file.close()

		puts "Wrote to #{ $GITIGNORE_FILE_NAME }".green
	end

	def self.downloadFromURL(url, name)
		begin
			response = RestClient.get(url, {:accept => "application/vnd.github.VERSION.raw"})
		rescue => e
			begin
				response = JSON.parse(e.response)
				puts "Error: #{ response["message"] }".red
			rescue JSON::ParserError => e
				puts "Failed to connect to Github and to parse error. Error: #{ e.response }".red
			end
			exit
		end

		"####### #{ File.basename(name, ".*") } #######\n#{ response.to_str.gsub(/\r/, "") }\n\n"
	end
	
	def self.searchTemplates(name)
		responseJSON = templatesFromURL($GITIGNORE_URL)
		
		selectionArray = Array.new
		
		responseJSON.each_with_index do |file_json, index|
			file_name = File.basename(file_json["name"], ".*")
			if file_name.downcase.include? name.downcase
				selectionArray << index
			end
		end
		
		if selectionArray.count <= 0
			puts "No template named #{ name }".red
		elsif selectionArray.count == 1
			# TODO download
		else
			# TODO multiple
		end
	end

	def self.displayTemplates
		responseJSON = templatesFromURL($GITIGNORE_URL)

		responseJSON.each_with_index do |file_json, index|
			file_name = File.basename(file_json["name"], ".*")
			puts "#{ index + 1 }: #{ file_name }"
		end

		selectionArray = Array.new

		begin
			print("Enter a number to download (0 to stop): ")
			selection = gets.to_i - 1
			if selectionArray.include? selection
				puts "#{ selection + 1 } was already entered.".red
			else
				if selection > 0 && selection < responseJSON.count
					selectionArray << selection
				else
					if selection > 0
						puts "#{ selection + 1 } is invalid".red
					end
				end
			end
		end while selection > 0

    if selectionArray.count < 1
      puts "No gitignores selected".red
      exit
    end

		gitignore = String.new
		selectionArray.each { |x| gitignore += downloadFromURL(responseJSON[x]["url"], responseJSON[x]["name"]) }

		writeGitignore(gitignore)
	end
end
