require 'test_helper'

class ClientTest < ActiveSupport::TestCase

  def setup
    @client = create(:client)
  end

  test "should be valid" do
    assert @client.valid?
  end
end
