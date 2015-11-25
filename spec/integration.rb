require 'capybara'
require 'capybara/dsl'
require 'rack/test'
require './app.rb'
require './spec/spec_helper'

Capybara.app = BudgetCommander.app
BudgetCommander.plugin :error_handler do |e|
  raise e
end

class Minitest::HooksSpec
  include Rack::Test::Methods
  include Capybara::DSL

  def app
    APP
  end

  def create_user(name:)
    User.create(:name => name, :password => 'test')
  end
end
