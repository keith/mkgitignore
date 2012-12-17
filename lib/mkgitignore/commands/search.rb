command :search do |c|
  c.syntax = 'mkgitignore search [template]'
  c.summary = 'Search avaliable gitignore templates'
  c.description = 'Searches all the templates in the Github gitignore templates repository'
  c.example 'Search for a specific template', 'mkgitignore search objective-c'
#  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    result = Array.new
    templates = Mkgitignore::templatesFromURL(Mkgitignore::GITIGNORE_URL)
    templates.each do |t|
      name = File.basename(t["name"], ".*")
      args.each do |arg|
        if name.casecmp(arg) == 0
          result << name
        end
      end
    end

    if result.count > 0
      puts result
    else
      puts "No matching templates found".red
  end
end
