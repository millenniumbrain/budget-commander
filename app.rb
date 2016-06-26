=begin
This is Budget Commander, command your budget everywhere you go

Tally, ho!
=end
require 'puma'
require 'roda'
require 'json'
require 'tilt/erubis'
require 'date'
require 'twilio-ruby'
require 'axlsx'
require 'openssl'
require 'jwt'
require 'better_errors'
require './models'
require './env'
require 'pp'

Dir['./helpers/*.rb'].each{ |f| require f }

class BudgetCommander < Roda

  plugin :default_headers,
         'Content-Type' => 'text/html',
         # 'Content-Security-Policy' => "default-src 'self'",
         'charset' => 'utf-8',
         'Strict-Transport-Security' => 'max-age=160704400',
         'X-Frame-Options' => 'deny',
         'X-Content-Type-Options' => 'nosniff'
  plugin :static, ['/css', '/fonts', '/img', '/js']
  plugin :json
  plugin :render, engine: 'erubis', views: 'views'
  plugin :cookies
  plugin :flash
  plugin :h
  plugin :environments
  plugin :flash
  plugin :render, engine: 'erubis'
  plugin :multi_route
  plugin :caching
  plugin :all_verbs
  plugin :not_found do
    render('404')
  end

  include Rack::Utils

  self.environment = :development

  configure do
    use Rack::Deflater
    use Rack::Session::Cookie, :secret => ENV['SECRET']
    use Rack::Session::Pool, :expire_after => 252000
  end

  configure :development do
    use Rack::MethodOverride
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  configure :production do
  end

  Roda.plugin JsonWebToken

  Dir['./routes/**/*.rb'].each { |f| require f }

  route do |r|
    r.multi_route

    r.is 'logout' do
      session[:user_id] = nil
      session[:logged_in] = nil
    end

    r.root do
      view 'index'
    end
  end
end
