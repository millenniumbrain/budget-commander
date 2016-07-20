source 'https://rubygems.org'

# => core
gem 'roda'
#gem 'twilio-ruby'
#gem 'rtesseract'
#gem "mini_magick"
#gem 'ruby-opencv'
#gem 'concurrent-ruby', require: 'concurrent'
gem 'druuid'
gem 'axlsx'
gem 'curb'
# => database
gem 'sequel'

# => security
gem 'bcrypt'
gem 'jwt'

# => templates
gem 'erubis'
gem 'tilt'
# => other
gem "rack_csrf"
gem 'mail'
group :production do
  #gem 'pg', :platform => :mri
  gem 'puma'
end

group :development do
  gem 'rubocop'
  gem 'jdbc-sqlite3', :platform => :jruby
  gem 'sqlite3', :platform => :mri
  gem 'sass'
  gem "binding_of_caller", :platform => :mri
end

group :test, :development do
  gem 'rake'
  gem 'rack-test', require: 'rack/test'
  gem 'better_errors'
  gem 'rspec'
  gem 'capybara'
end
