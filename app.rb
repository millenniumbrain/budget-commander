=begin
This is Budget Commander, command your budget everywhere you go

Tally, ho!
=end
require 'puma'
require 'roda'
require 'json'
require 'slim'
require 'tilt/erubis'
require 'date'
require 'twilio-ruby'
require 'axlsx'
require 'better_errors'
require './models'
require './env'
require './lib/wit_ai.rb'
require 'pp'

Dir['./helpers/*.rb'].each{ |f| require f }

class BudgetCommander < Roda

  plugin :default_headers,
    'Content-Type' => 'text/html',
    #'Content-Security-Policy' => "default-src 'self'",
    'charset' => 'utf-8',
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
  plugin :render, :engine => 'erubis'
  plugin :multi_route
  plugin :caching
  plugin :not_found do
    render('404')
  end
  
  include Rack::Utils
  
  # custom plugins
  Roda.plugin JSONParserHelper

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

  Dir['./routes/**/*.rb'].each{ |f| require f }

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
