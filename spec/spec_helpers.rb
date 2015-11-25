require 'minitest/autorun'
require 'minitest/hooks/default'

class Minitest::HookSpec
  around(:all) do |&block|
    DB.transaction(:rollback => :always) {super(&block)}
  end

  around do |&block|
    DB.transaction(:rollback=>:always, :savepoints => true){super(&block)}
  end

  if defined?(Capybara)
    after do
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end
  end
end
