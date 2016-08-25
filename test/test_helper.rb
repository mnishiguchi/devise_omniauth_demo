require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "mocha/mini_test"

# Minitest-reporters is a progress-bar-style reporter by default but
# we can use a document-style reporter instead.
# https://github.com/kern/minitest-reporters#caveats
require "minitest/reporters"
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

# Capybara
require 'minitest/rails/capybara'
require 'capybara-screenshot/minitest'
require "capybara/poltergeist"
Capybara.javascript_driver = :poltergeist

# Shoulda-matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

# Retry
require 'minitest/retry'
Minitest::Retry.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Make FactoryGirl code concise.
  include FactoryGirl::Syntax::Methods

  # Make helpers available in tests.
  include ApplicationHelper
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

# See: https://gist.github.com/mperham/3049152
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || ConnectionPool::Wrapper.new(:size => 1) { retrieve_connection }
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
