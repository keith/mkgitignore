command :append do |c|
  c.syntax = 'mkgitignore append TEMPLATE_NAMES [options]'
  c.summary = 'Appends the current gitignore with the passed templates'
  c.description = 'Combines passed Gitignore templates and appends your gitignore with the result'
  c.example 'Append to your gitignore file with multiple passed templates', 'mkgitignore append osx objective-c'
  c.option '--dry-run', 'Prints out the would be contents of the gitignore'
  c.action do |args, options|
    if args.count < 1
      puts 'You must enter one or more template names. `mkgitignore append -h` for usage'.red
      exit
    end

    templates = Mkgitignore::searchForTemplatesWithNames(args)

    gitignore = String.new
    templates.each { |t| gitignore += Mkgitignore::downloadFromURL(t["url"], t["name"]) }

    if options.dry_run
      puts gitignore
    else
      Mkgitignore::appendGitignore(gitignore)
    end
  end
end

