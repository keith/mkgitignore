require 'mkgitignore/version'
require 'rest-client'
require 'colored'
require 'json'

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
      file_array = Array.new
      begin
        json = JSON.parse(response.body)
      rescue JSON::ParserError => e
        puts "Failed to decode response #{ e.response }".red
        exit
      end

      json.each do |file|
        name = file["name"].to_s
        if name.include? ".gitignore"
          file_array << file
        else
          if file["type"] == "dir"
            file_array += templatesFromURL(file["url"])
          end
        end
      end

      file_array.sort! { |x, y| x["name"] <=> y["name"] }
      file_array
    else
      puts "Github returned an error #{ response }".red
    end
  end

  def self.searchForTemplatesWithNames(names)
    result = Array.new
    templates = Mkgitignore::templatesFromURL(Mkgitignore::GITIGNORE_URL)
    templates.each do |t|
      file_name = File.basename(t["name"], ".*")
      names.each do |name|
        if name.casecmp(file_name) == 0
          result << t
        end
      end
    end

    result
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

  def self.printAllTemplates
    templates = Mkgitignore::templatesFromURL(Mkgitignore::GITIGNORE_URL)
    templates.each_with_index do |template, index|
      file_name = File.basename(template["name"], ".*")
      puts "#{ index + 1}: #{ file_name }"
    end

    selectionArray = Array.new

    begin
      print("Enter a number to download (0 to stop): ")
      selection = $stdin.gets.to_i - 1
      if selectionArray.include? selection
        puts "#{ selection + 1 } was already entered.".red
      else
        if selection > 0 && selection < templates.count
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
    # selectionArray.each { |t| gitignore += Mkgitignore::downloadFromURL(t["url"], t["name"]) }
    selectionArray.each { |x| gitignore += Mkgitignore::downloadFromURL(templates[x]["url"], templates[x]["name"]) }

    gitignore
  end

  def self.writeGitignore(gitignore, nobackup)
    if nobackup.nil? && File.exists?(Mkgitignore::GITIGNORE_FILE_NAME)
      FileUtils.mv Mkgitignore::GITIGNORE_FILE_NAME, Mkgitignore::BACKUP_FILE_NAME, :force => true
      if File.exists?(Mkgitignore::GITIGNORE_FILE_NAME)
        puts "Failed to backup #{ Mkgitignore::GITIGNORE_FILE_NAME }".red
      else
        puts "Backed up to #{ Mkgitignore::BACKUP_FILE_NAME }".green
      end
    end

    if File.exists?(Mkgitignore::GITIGNORE_FILE_NAME)
      FileUtils.rm(Mkgitignore::GITIGNORE_FILE_NAME, :force => true)
      if File.exists?(Mkgitignore::GITIGNORE_FILE_NAME)
        puts "Failed to remove old #{ Mkgitignore::GITIGNORE_FILE_NAME }".red
      else
        puts "Removed old #{ Mkgitignore::GITIGNORE_FILE_NAME }".green
      end
    end

    file = File.open(Mkgitignore::GITIGNORE_FILE_NAME, "w")
    file << gitignore
    file.close()
    puts "Finished writing #{ Mkgitignore::GITIGNORE_FILE_NAME }".green
  end

  def self.appendGitignore(gitignore)
    if File.exists?(Mkgitignore::GITIGNORE_FILE_NAME)
      File.open(Mkgitignore::GITIGNORE_FILE_NAME, 'a') do |file|
        file << gitignore
      end
    else
      writeGitignore(gitignore, true)
    end
  end
end


require 'mkgitignore/commands/list'
require 'mkgitignore/commands/search'
require 'mkgitignore/commands/build'
require 'mkgitignore/commands/listbuild'
