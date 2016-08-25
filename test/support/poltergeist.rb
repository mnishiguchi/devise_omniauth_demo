require 'capybara/poltergeist'

# We want to use poltergeist only when we test javascript features
# so that the rest of the test suite can run faster.
# So we set the current_driver of capybara to nil after each test.
class ActiveSupport::TestCase

  def setup
    Capybara.javascript_driver = :poltergeist
  end
  
  def teardown
    Capybara.current_driver = nil
  end
end
