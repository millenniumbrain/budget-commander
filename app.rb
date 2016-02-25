=begin
# This library is to provide a framework for using modern tools
# to leverage the power of a cms service
=end
require 'puma'
require 'roda'
require 'json'
require 'slim'
require 'date'
require 'ffi'
require_relative 'lib/time_shift'
require_relative 'lib/total_budget'
require_relative 'lib/total_income'
require_relative 'lib/total_expense'
require 'better_errors'
require './models'
require './env'

Dir['./helpers/*.rb'].each{ |f| require f }

class BudgetCommander < Roda

  plugin :default_headers,
  'Content-Type' => 'text/html',
  #'Content-Security-Policy' => "default-src 'self'",
  'Strict-Transport-Security' => 'max-age=160704400',
  'X-Frame-Options' => 'deny',
  'X-Content-Type-Options' => 'nosniff'
  plugin :static, ['/css', '/fonts', '/img', '/js']
  plugin :json
  plugin :render, :engine => 'slim', :views => 'views'
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

  # custom plugins
  Roda.plugin JSONParserHelper

  self.environment = :development

  configure do
    use Rack::Session::Cookie, :secret => ENV['SECRET']
    use Rack::Session::Pool, :expire_after => 252000
  end

  configure :development do
    Slim::Engine.set_options :pretty => true, :sort_attrs => true
    use Rack::MethodOverride
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  configure :production do
  end

  Dir['./routes/*.rb'].each{ |f| require f }

  route do |r|
    r.multi_route

    r.root do

    end
  end
end
