require 'mkgitignore/version'
require 'rest-client'
require 'colored'
require 'JSON'

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

  def self.searchTemplatesForNames(names)
    result = Array.new
    templates = Mkgitignore::templatesFromURL(Mkgitignore::GITIGNORE_URL)
    templates.each do |t|
      name = File.basename(t["name"], ".*")
      names.each do |name|
        if name.casecmp(name) == 0
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
end


require 'mkgitignore/commands/list'
require 'mkgitignore/commands/search'
require 'mkgitignore/commands/build'

