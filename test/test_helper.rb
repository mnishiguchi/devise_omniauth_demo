ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# minitest-reporters
# https://github.com/kern/minitest-reporters#caveats
require "minitest/reporters"
Minitest::Reporters.use!

# Capybara
require 'minitest/rails/capybara'
require 'capybara-screenshot/minitest'

# Shoulda-matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Make FactoryGirl code concise.
  include FactoryGirl::Syntax::Methods

  # Make helpers available in tests.
  include ApplicationHelper
end
