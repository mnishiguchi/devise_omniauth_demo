require 'test_helper'

class AdminTest < ActiveSupport::TestCase

  def setup
    @admin = create(:admin)
  end

  test "should be valid" do
    assert @admin.valid?
  end
end
