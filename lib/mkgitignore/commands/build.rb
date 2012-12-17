command :build do |c|
  c.syntax = 'mkgitignore build TEMPLATE_NAMES [options]'
  c.summary = 'Create a new gitignore with the passed templates'
  c.description = ''
  c.example 'Create a gitignore file with multiple passed templates', 'mkgitignore build osx objective-c'
  c.option '-f', 'Force overwrite previous gitignore'
  c.option '--force', 'Some switch that does something'
  c.action do |args, options|
  	
  end
end
