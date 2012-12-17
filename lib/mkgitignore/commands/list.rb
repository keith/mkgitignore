command :list do |c|
  c.syntax = 'mkgitignore list'
  c.summary = 'List all the avaliable gitignore templates'
  c.description = 'Prints every template within all subfolders of the Github Gitignore templates repository'
#  c.example 'description', 'command example'
#  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    Mkgitignore::templatesFromURL(Mkgitignore::GITIGNORE_URL).each { |template| puts File.basename(template["name"], ".*") }
  end
end
