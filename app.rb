=begin
This is Budget Commander, command your budget everywhere you go

Tally, ho!
=end
require 'puma'
require 'roda'
require 'json'
require 'slim'
require 'erubis'
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
  plugin :render, :engine => 'erubis'
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
    use Rack::MethodOverride
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  configure :production do
  end

  Dir['./routes/*.rb'.freeze].each{ |f| require f }

  route do |r|
    r.multi_route

    r.is 'login' do
      r.get do
        @title = "Log In"
        view 'users/login', layout: 'users/layout'
      end
      
      r.post do
        user = r["user"]
        if User.login(user["email"], user["password"])
          current_user = User.where(:email => user[:email])
          session[:user_id] = current_user.id
          session[:logged_in] = true
        else
        end
      end
    end
    
    r.is 'signup' do
      r.get do
        @title = "Sign Up"
        view 'users/signup', layout: 'users/layout'
      end
      
      r.post do
        user = r["user"]
        if User.where(:email => user["email"]).nil?
        else
          new_user = User.new do |u|
            u.email = user["email"]
            u.password = user["password"]
          end
          new_user.save
        end
      end
    end
    
    r.is 'logout' do
      session[:user_id] = nil
      session[:logged_in] = nil
    end
    
    r.root do
      view 'index'
    end
  end
end
