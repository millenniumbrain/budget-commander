require 'sequel'
require 'logger'
require 'yard'

namespace :db do
  desc 'creates new test table'
  task :new do
    file = File.new 'db/test.sqlite', 'w+'
    file.close
  end

  namespace :sqlite do
    desc 'runs sqlite migrations'
    task :migrate do
      DB = Sequel.sqlite('db/test.sqlite')
      DB.loggers << Logger.new($stdout)
      Sequel.extension :migration
      Sequel::Migrator.apply(DB, 'migrations')
    end
  end

  namespace :postgress do
    task :migrate do
      DB = Sequel.connect(ENV['DATABASE_URL'])
      DB.loggers << Logger.new($stdout)
      Sequel.extension :migration
      Sequel::Migrator.apply(DB, 'migrations')
    end
  end
end


YARD::Rake::YardocTask.new do |t|
  t.files = ['./app.rb', 'routes/*.rb', './models/*.rb', './helpers/*.rb']
  t.options = ['--output-dir', 'doc']
end
