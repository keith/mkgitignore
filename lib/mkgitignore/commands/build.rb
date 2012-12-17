command :build do |c|
  c.syntax = 'mkgitignore build TEMPLATE_NAMES [options]'
  c.summary = 'Create a new gitignore with the passed templates'
  c.description = 'Combines passed Gitignore templates and creates a new gitignore with the result'
  c.example 'Create a gitignore file with multiple passed templates', 'mkgitignore build osx objective-c'
  c.option '--no-backup', 'Doesn\'t back up previous gitignore to backup.gitignore'
  c.option '--dry-run', 'Prints out the would be contents of the gitignore'
  c.action do |args, options|
    if args.count < 1
      puts "You must enter one or more template names. `mkgitignore build -h` for usage".red
      exit
    end

    templates = Mkgitignore::searchForTemplatesWithNames(args)

    gitignore = String.new
    templates.each { |t| gitignore += Mkgitignore::downloadFromURL(t["url"], t["name"]) }

    if options.dry_run
      puts gitignore
    else
      Mkgitignore::writeGitignore(gitignore, options.no_backup)
    end
  end
end
