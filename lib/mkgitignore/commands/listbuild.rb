command :listbuild do |c|
  c.syntax = 'mkgitignore listbuild'
  c.summary = 'Create a gitignore by choosing from the master list'
  c.description = 'Displays a list of every avaliable gitignore and asks for templates to add to the gitignore'
  c.example 'Display the list and choose templates', 'mkgitignore listbuild'
  c.option '--no-backup', 'Doesn\'t back up previous gitignore to backup.gitignore'
  c.option '--dry-run', 'Prints out the would be contents of the gitignore'
  c.action do |args, options|
    gitignore = Mkgitignore::printAllTemplates

    if options.dry_run
      puts gitignore
    else
      Mkgitignore::writeGitignore(gitignore, options.no_backup)
    end
  end
end

