require 'logger'
require 'sequel'
require 'bcrypt'
require 'jdbc/sqlite3'
require 'java'

DB = Sequel.connect('jdbc:sqlite:db/test.sqlite')
DB.loggers << Logger.new($stdout)

Sequel.default_timezone = :utc
Sequel::Model.plugin :timestamps, :update_on_create => true

Dir[File.dirname(__FILE__) + '/models/*.rb'].each do |file|
  require file
end
