=begin
# This library is to provide a framework for using modern tools
# to leverage the power of a cms service
=end
require 'puma'
require 'roda'
require 'json'
require 'slim'
require 'date'
require 'twilio-ruby'
require 'axlsx'
require 'better_errors'
require './models'
require './env'

Dir['./helpers/*.rb'.freeze].each{ |f| require f }

class BudgetCommander < Roda

  plugin :default_headers,
    'Content-Type'.freeze => 'text/html'.freeze,
  #'Content-Security-Policy' => "default-src 'self'",
    'Strict-Transport-Security'.freeze => 'max-age=160704400'.freeze,
    'X-Frame-Options'.freeze => 'deny'.freeze,
    'X-Content-Type-Options'.freeze => 'nosniff.freeze'
  plugin :static, ['/css'.freeze, '/fonts'.freeze, '/img'.freeze, '/js'.freeze]
  plugin :json
  plugin :render, :engine => 'slim', :views => 'views'
  plugin :cookies
  plugin :flash
  plugin :h
  plugin :environments
  plugin :flash
  plugin :render
  plugin :multi_route
  plugin :caching
  plugin :not_found do
    render('404'.freeze)
  end

  # custom plugins
  Roda.plugin JSONParserHelper

  self.environment = :development

  configure do
    use Rack::Deflater
    use Rack::Session::Cookie, :secret => ENV['SECRET'.freeze]
    use Rack::Session::Pool, :expire_after => 252000
  end

  configure :development do
    #Slim::Engine.set_options :pretty => true, :sort_attrs => true
    use Rack::MethodOverride
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  configure :production do
  end

  Dir['./routes/*.rb'.freeze].each{ |f| require f }

  route do |r|
    r.multi_route

    r.root do

    end
  end
end
