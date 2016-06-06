require 'logger'
require 'sequel'
require 'bcrypt'
require 'securerandom'

DB = Sequel.sqlite('db/test.sqlite')
DB.loggers << Logger.new($stdout)

Sequel.default_timezone = :utc
Sequel::Model.plugin :timestamps, :update_on_create => true

Dir[File.dirname(__FILE__) + '/models/*.rb'].each do |file|
  require file
end
