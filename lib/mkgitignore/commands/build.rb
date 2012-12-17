command :build do |c|
  c.syntax = 'mkgitignore build TEMPLATE_NAMES [options]'
  c.summary = 'Create a new gitignore with the passed templates'
  c.description = ''
  c.example 'Create a gitignore file with multiple passed templates', 'mkgitignore build osx objective-c'
  c.option '--backup', 'Backs up previous gitignore to backup.gitignore'
  c.option '--force', 'Force overwrite previous gitignore'
  c.option '--dry-run', 'Prints out the would be contents of the gitignore'
  c.action do |args, options|
  	puts args.inspect
    puts options.force
    puts options.backup
    puts options.dry_run
  end
end
