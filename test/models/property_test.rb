require "test_helper"

describe Property do
  let(:property) { create(:property) }

  it "must be valid" do
    assert property.valid?
  end
end
