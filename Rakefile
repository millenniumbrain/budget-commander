require 'sequel'
require 'logger'

namespace :sqlite do
  task :new do
    file = File.new 'db/test.sqlite', 'w+'
    file.close
  end

  desc 'runs database migrations'
  task :migrate do
    system('mkdir db')
    DB = Sequel.sqlite('db/test.sqlite')
    DB.loggers << Logger.new($stdout)
    Sequel.extension :migration
    Sequel::Migrator.apply(DB, 'migrations')
  end

  task :delete do
  end
end


namespace :test do
  task :models do

  end

  task :integraiton do

  end
end
