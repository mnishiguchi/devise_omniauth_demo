# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  likeable_id   :integer
#  likeable_type :string
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "test_helper"

describe Like do
  let(:like) { create(:like) }

  it "must be valid" do
    assert like.valid?
  end
end
