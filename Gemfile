source 'https://rubygems.org'

# => core
gem 'roda'
gem 'concurrent-ruby'
gem 'concurrent-ruby-ext'
# => database
gem 'sequel'


# => security
gem 'bcrypt'

# => templates
gem 'tilt'
gem 'erubis'

# => other
gem "rack_csrf"
gem 'mail'
gem 'json'
group :production do
  gem 'pg'
  gem 'puma'
end

group :development do
  gem 'sqlite3'
  gem 'sass'
  gem 'yard'
  gem 'shotgun'
end

group :test, :development do
  gem 'sqlite3'
  gem 'rake'
  gem 'rack-test', require: 'rack/test'
  gem 'better_errors'
  gem 'minitest'
  gem 'capybara'
  gem "minitest-hooks"
end
