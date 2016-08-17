require 'test_helper'

class AccountExecutiveTest < ActiveSupport::TestCase

  def setup
    @account_executive = create(:account_executive)
  end

  test "should be valid" do
    assert @account_executive.valid?
  end
end
