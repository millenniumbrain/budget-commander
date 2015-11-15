=begin
# This library is to provide a framework for using modern tools
# to leverage the power of a cms service
=end
require 'puma'
require 'roda'
require 'builder'
require 'tilt'
require 'tilt/erubis'
require 'json'
require 'tilt'
require 'bcrypt'
require_relative 'lib/time_shift'
require_relative 'lib/total_income'
require_relative 'lib/total_expenses'
require 'better_errors'
require 'pp'
require 'logger'
require './models'

class BudgetCommander < Roda

  plugin :json
  plugin :render
  plugin :cookies
  plugin :flash
  plugin :h
  plugin :environments
  plugin :flash
  plugin :render
  plugin :multi_route
  plugin :not_found do
    render('404')
  end

  self.environment = :development

  configure do
    use Rack::Session::Cookie, secret: '3edqw32ed2w' #ENV['SECRET']
    use Rack::Session::Pool, expire_after: 252000
  end

  configure :development do
    use Rack::MethodOverride
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  configure :production do
  end

  Dir['./routes/*.rb'].each{ |f| require f }
  Dir['./routes/users/*.rb'].each{ |f| require f }

  route do |r|
    r.multi_route

    r.root do

    end
  end

  Dir['./helpers/*.rb'].each{ |f| require f }
end
