command :search do |c|
  c.syntax = 'mkgitignore search TEMPLATE_NAMES'
  c.summary = 'Search avaliable gitignore templates'
  c.description = 'Searches all the templates in the Github gitignore templates repository'
  c.example 'Search for a specific template', 'mkgitignore search objective-c'
  c.action do |args, options|
    templates = Mkgitignore::searchForTemplatesWithNames(args)
    if templates.count > 0
      templates.each { |t| puts File.basename(t["name"], ".*") }
    else
      puts "No matching templates found".red
    end
  end
end
